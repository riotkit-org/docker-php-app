#!/bin/bash

echo " >> Setting permissions"

set -x;

# older versions of Alpine Linux
if ! command -v usermod 2> /dev/null; then
    userdel www-data
    groupdel www-data

    addgroup www-data --gid "${WWW_GROUP_ID}"
    adduser www-data --home /var/www --shell /bin/bash --ingroup www-data --uid "${WWW_USER_ID}"
else
    # newer versions of Alpine Linux can use "shadow"
    usermod -u "${WWW_USER_ID}" www-data
    groupmod -g "${WWW_GROUP_ID}" www-data
fi
