#!/bin/bash

SLACK_URL=$1
MESSAGE=$2

[[ "$SLACK_URL" ]] && echo "{\"text\": \"${MESSAGE}\"}" | curl -H 'Content-type: application/json' -d @- -X POST -s "${SLACK_URL}";

exit 0
