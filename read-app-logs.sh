#!/bin/bash

while [[ ! -f /var/www/html/var/log/prod.log ]]; do
    sleep 1
done

exec tail -f /var/www/html/var/log/prod.log
