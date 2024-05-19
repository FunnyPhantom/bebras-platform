FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ARG USE_IR=false

WORKDIR /etc/apt
COPY ubuntu-source.list.ir /etc/apt/sources.list.ir
RUN if [ "$USE_IR" = "true" ]; then mv sources.list.ir sources.list; fi

RUN echo "Building with $(if [ "$USE_IR" = "true" ]; then echo "Iranian"; else echo "default"; fi) sources"



# Install necessary packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    zip \
    unzip \
    git \
    supervisor \
    sqlite3 \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    apache2

# Enable apache modules
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http

# Add repository for PHP 7.2
RUN add-apt-repository -y ppa:ondrej/php

## Install PHP 7.2 and some extensions
RUN apt-get update && apt-get install -y \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-json \
    php7.2-xml \
    php7.2-mbstring \
    php7.2-zip \
    php7.2-gd \
    php7.2-sqlite3 \
    php7.2-mysql \
    php7.2-intl


## configure php to work with apache
RUN apt-get install -y libapache2-mod-php7.2
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7.2
RUN service apache2 restart



# Intall composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js version 18
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g bower

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html/bebras-platform

# Copy project files into docker image
COPY . .

# Install PHP dependencies
RUN composer install

# Change working directory to contestInterface
WORKDIR /var/www/html/bebras-platform/contestInterface
# Run Bower install
RUN bower install --allow-root


# Change Working directory to teacherInterface
WORKDIR /var/www/html/bebras-platform/teacherInterface
# Run Bower install
RUN bower install --allow-root

WORKDIR /var/www/html/bebras-platform

# Expose port 80
EXPOSE 80




# Copy apache configuration file
COPY apache-confs/base.conf /etc/apache2/sites-available/000-default.conf
COPY apache-confs/.htpasswd /etc/apache2/.htpasswd

# enable apache configuration
RUN a2ensite 000-default.conf
RUN service apache2 restart

# Start apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]