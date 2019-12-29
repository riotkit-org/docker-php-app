#!/bin/bash

echo " >> Checking if commands are present"
set -xe
command -v php
command -v php-fpm
command -v nginx
