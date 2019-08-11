#!/bin/bash

set -e;

# backup volume-mounted config
[[ -f /etc/nginx/nginx.conf ]] && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

export CONFIGS_PATH=${CONFIGS_PATH:-/.etc.template}
export CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH:-/etc}

# copy required non-templates to /etc
cp -pr /.etc.template/nginx/fastcgi-php.conf /etc/nginx/fastcgi-php.conf

# render templates into $CONFIGS_DEST_PATH
/render-jinja-files.sh

echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
cp -pr ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/

echo " >> Restoring NGINX config from backup if there was any"
[[ -f /etc/nginx/nginx.conf.bak ]] && mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf

echo " >> Testing NGINX configuration"
nginx -t -c ${CONFIGS_DEST_PATH}/nginx/nginx.conf
