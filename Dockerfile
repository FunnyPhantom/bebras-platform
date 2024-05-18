# Start from base Ubuntu 22.04 image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

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
    libssl-dev

# Add repository for PHP 7.2
RUN add-apt-repository -y ppa:ondrej/php

# Install PHP 7.2 and some extensions
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
    php7.2-mysql

# Intall composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js version 18
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g bower

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy project files into docker image
COPY . .

# Install PHP dependencies
RUN composer install

# Change working directory to contestInterface
WORKDIR /var/www/html/contestInterface
# Run Bower install
RUN bower install --allow-root


# Change Working directory to teacherInterface
WORKDIR /var/www/html/teacherInterface
# Run Bower install
RUN bower install --allow-root

# Expose port 80
EXPOSE 80
