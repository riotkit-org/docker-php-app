#!/bin/bash

set -e;

CONFIGS_PATH=/.usr.template
CONFIGS_DEST_PATH=/usr

CONFIGS_PATH=${CONFIGS_PATH} CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH} render-jinja-files.sh

echo " >> Copying all configuration files to the ${CONFIGS_DEST_PATH}"
set -x; cp -pr ${CONFIGS_PATH}/* ${CONFIGS_DEST_PATH}/
ls -la ${CONFIGS_DEST_PATH}

echo " >> Testing PHP configuration"
php -v
php -i > /dev/null
