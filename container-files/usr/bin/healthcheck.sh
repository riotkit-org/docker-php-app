#!/bin/bash

HEALTHCHECK=${HEALTHCHECK:-curl --fail --insecure --location http://localhost/}

exec bash -c "${HEALTHCHECK}"
