#!/bin/bash

set -e;

# backup volume-mounted config
[[ -f /etc/nginx/nginx.conf ]] && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

CONFIGS_PATH=${CONFIGS_PATH:-/.etc.template}
CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH:-/etc}

for file in $(find ${CONFIGS_PATH} -name '*.j2'); do
    target_path=${file/.j2/}

    echo " >> Rendering file ${file} into ${target_path}"
    j2 ${file} > ${target_path}
done


echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
cp -pr ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/

echo " >> Restoring NGINX config from backup if there was any"
[[ -f /etc/nginx/nginx.conf.bak ]] && mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf

echo " >> Testing NGINX configuration"
nginx -t
