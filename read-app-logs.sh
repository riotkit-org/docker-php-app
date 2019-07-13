#!/bin/bash

LOG_FILE_NAME=${APP_ENV:-prod}

while [[ ! -f "/var/www/html/var/log/${LOG_FILE_NAME}.log" ]]; do
    sleep 1
done

exec tail -f "/var/www/html/var/log/${LOG_FILE_NAME}.log"
