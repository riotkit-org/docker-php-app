#!/bin/bash

set -e

echo " >> Checking if GD has jpeg support"
echo "<?php function_exists('imagecreatefromjpeg') || exit(1);" | php
