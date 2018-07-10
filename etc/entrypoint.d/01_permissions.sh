#!/bin/bash

echo " >> Setting up Symfony-specific permissions"
mkdir -p /var/www/vendor /var/www/var/cache
chown www-data:www-data /var/www/vendor /var/www/var /var/www/public /var/www/web -R
