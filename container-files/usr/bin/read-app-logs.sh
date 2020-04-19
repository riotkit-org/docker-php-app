#!/bin/bash

LOG_FILE_NAME=${APP_ENV:-prod}
APP_LOG_PATH=${APP_LOG_PATH:-"/var/www/html/var/log/${LOG_FILE_NAME}.log"}
SECONDS_TO_WAIT=${WAIT_FOR_LOG:-120}

echo " >> Waiting for ${APP_LOG_PATH} to appear"

while [[ "${SECONDS_TO_WAIT}" != "0" ]]; do
    if [[ -f "${APP_LOG_PATH}" ]]; then
        break
    fi

    sleep 1
    SECONDS_TO_WAIT=$((SECONDS_TO_WAIT-1))
    echo -n "."
done

echo ""
exec tail -q -f "${APP_LOG_PATH}" \
             -f /var/log/supervisor/*.log
