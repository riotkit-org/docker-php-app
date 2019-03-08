#!/bin/bash
for file_name in /entrypoint.d/*sh
do
    if [ -e "${file_name}" ]; then
        echo " >> entrypoint.d - executing $file_name"
        . "${file_name}"
    fi
done

touch /var/log/cron.log || true
chown www-data:www-data /var/log/cron.log

echo " >> Running supervisord..."
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

LOGS="-f /var/log/cron.log"

if [[ -f /var/www/html/var/log/prod.log ]]; then
    LOGS="${LOGS} -f /var/www/html/var/log/prod.log"
fi

if [[ -f /var/log/nginx/access.log ]]; then
    LOGS="${LOGS} -f /var/log/nginx/access.log"
fi

if [[ -f /var/log/nginx/error.log ]]; then
    LOGS="${LOGS} -f /var/log/nginx/error.log"
fi

exec tail ${LOGS}
