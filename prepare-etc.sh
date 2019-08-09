#!/bin/bash

set -e;

# backup volume-mounted config
[[ -f /etc/nginx/nginx.conf ]] && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

export CONFIGS_PATH=${CONFIGS_PATH:-/.etc.template}
export CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH:-/etc}

/render-jinja-files.sh

echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
cp -pr ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/

echo " >> Restoring NGINX config from backup if there was any"
[[ -f /etc/nginx/nginx.conf.bak ]] && mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf

echo " >> Testing NGINX configuration"
nginx -t -c ${CONFIGS_DEST_PATH}/nginx/nginx.conf
