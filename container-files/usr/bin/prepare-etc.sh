#!/bin/bash

set -e;

# backup volume-mounted config
if [[ -f /etc/nginx/nginx.conf ]]; then
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
fi

export CONFIGS_PATH=${CONFIGS_PATH:-/.etc.template}
export CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH:-/etc}

# copy required non-templates to /etc
mkdir -p "${CONFIGS_DEST_PATH}/nginx"
cp -prv ${CONFIGS_PATH}/nginx/fastcgi-php.conf ${CONFIGS_DEST_PATH}/nginx/fastcgi-php.conf
cp -prv ${CONFIGS_PATH}/nginx/fastcgi-php.conf /etc/nginx/fastcgi-php.conf  # required for test mode

# render templates into $CONFIGS_DEST_PATH
render-jinja-files.py

echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
cp -prv ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/

if [[ -f /etc/nginx/nginx.conf.bak ]]; then
    echo " >> Restoring NGINX config from backup"
    mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
fi

echo " >> Testing NGINX configuration"
nginx -t -c "${CONFIGS_DEST_PATH}/nginx/nginx.conf"
