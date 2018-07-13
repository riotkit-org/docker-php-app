#!/bin/bash

echo " >> Setting up Symfony-specific permissions"
mkdir -p /var/www/html/vendor /var/www/html/var/cache

chown www-data:www-data /var/www/html/vendor /var/www/html/vendor/*
chown www-data:www-data /var/www/html/var /var/www/html/public /var/www/html/web -R
