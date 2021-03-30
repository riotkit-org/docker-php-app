#!/bin/bash

set -e

prepare-etc.sh
prepare-usr.sh

for file_name in /entrypoint.d/*sh
do
    if [ -e "${file_name}" ]; then
        echo " >> entrypoint.d - executing $file_name"
        . "${file_name}"
    fi
done

touch /var/log/cron.log
chown www-data:www-data /var/log/cron.log

echo " >> Spawning services..."
exec multirun -v "nginx" "php-fpm -F -O" "read-app-logs.sh" "crond -l 2 -f"
