#!/bin/bash

cd /var/www/html

if [[ -f ./composer.json ]]; then
    su www-data -c composer install
fi
