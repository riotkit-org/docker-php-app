#!/bin/bash

apk add --update shadow || true

set -xe

/entrypoint.d/02_user.sh
