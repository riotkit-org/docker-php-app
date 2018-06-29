#!/bin/bash

if [[ -d /var/www/html/var ]]; then
    chown www-data:www-data /var/www/html/var -R
fi
