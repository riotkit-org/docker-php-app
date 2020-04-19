#!/bin/bash

set -e

echo " >> Checking if True Type Fonts is available in GD extension"
echo "<?php function_exists('imagettftext') || exit(1);" | php
