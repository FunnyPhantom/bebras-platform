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

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get install -y nodejs

# Install Bower
RUN npm install -g bower

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy project files into docker image
COPY . .

# Change working directory to contestInterface
WORKDIR /var/www/html/contestInterface
# Run Bower install
RUN bower install --allow-root

# Expose port 80
EXPOSE 3200

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:3200", "-t", "/var/www/html"]