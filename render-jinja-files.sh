#!/bin/bash

CONFIGS_PATH=${CONFIGS_PATH:-/.etc.template}
CONFIGS_DEST_PATH=${CONFIGS_DEST_PATH:-/etc}

echo " ==> Rendering JINJA2 files from ${CONFIGS_PATH} to ${CONFIGS_DEST_PATH}"

for file in $(find ${CONFIGS_PATH} -name '*.j2'); do
    target_path=${file/.j2/}

    echo " >> Rendering file ${file} into ${target_path}"
    j2 ${file} > ${target_path}
done
