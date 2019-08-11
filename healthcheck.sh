#!/bin/bash

HEALTHCHECK=${HEALTHCHECK:-curl -f http://localhost/ --fail}

exec bash -c "${HEALTHCHECK}"
