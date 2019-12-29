#!/bin/bash

set -e

/prepare-etc.sh
/prepare-usr.sh

for file_name in /entrypoint.d/*sh
do
    if [ -e "${file_name}" ]; then
        echo " >> entrypoint.d - executing $file_name"
        . "${file_name}"
    fi
done

touch /var/log/cron.log
chown www-data:www-data /var/log/cron.log

echo " >> Running supervisord..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

exec /read-app-logs.sh
