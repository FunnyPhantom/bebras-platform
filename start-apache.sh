#!/bin/bash

# Set ServerName to suppress warnings
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set locale environment variables
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Log start of script
echo "$(date): Starting Apache setup script"

# Check if SSL certificates exist and enable SSL if they do
if [ -f /etc/letsencrypt/live/learn-python.ir/fullchain.pem ] && [ -f /etc/letsencrypt/live/learn-python.ir/privkey.pem ]; then
    echo "$(date): SSL certificates found, enabling SSL site..."
    a2ensite default-ssl.conf
    if [ $? -ne 0 ]; then
        echo "$(date): Failed to enable SSL site"
        exit 1
    fi
else
    echo "$(date): SSL certificates not found, skipping SSL site enablement."
fi

# Start Apache in the foreground
echo "$(date): Starting Apache in the foreground"
exec /usr/sbin/apache2ctl -D FOREGROUND

# If Apache stops, log it
echo "$(date): Apache stopped running"
exit 1

