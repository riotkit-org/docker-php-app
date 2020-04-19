#!/bin/bash

set -e

for i in $(find /opt/tests/ -type f | sort -V); do
    echo "Running test ${i}"
    chmod +x "${i}"
    ${i} || (echo "${i} failed." && exit 1)
done;
