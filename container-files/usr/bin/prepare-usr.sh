#!/bin/bash

set -e;

CONFIGS_PATH=/.usr.template
CONFIGS_DEST_PATH=/usr

CONFIGS_PATH=${CONFIGS_PATH} CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH} render-jinja-files.py

echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
set -x; cp -prv ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/

echo " >> Testing PHP configuration"
php -v
php -i > /dev/null
