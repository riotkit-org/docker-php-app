#!/bin/bash

cd /var/www/html

if [[ -f ./composer.json ]]; then
    su www-data -s /bin/bash -c "composer install"
fi
