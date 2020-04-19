#!/bin/bash

apk add py3-pip || true

if ! command -v pip3 >/dev/null; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
fi
