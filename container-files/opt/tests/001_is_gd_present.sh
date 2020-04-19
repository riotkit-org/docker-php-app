#!/bin/bash

set -e

echo " >> Checking if GD extension is present"
echo "<?php extension_loaded('gd') || exit(1);" | php
