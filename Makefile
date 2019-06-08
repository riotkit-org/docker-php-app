#!make

#include .env
#export $(shell sed 's/=.*//' .env)

.SILENT:

SHELL := /bin/bash

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## This help dialog
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Build x86_64 image
build@x86_64:
	sudo docker build . -f ./Dockerfile -t wolnosciowiec/docker-php-app
	sudo docker tag wolnosciowiec/docker-php-app quay.io/riotkit/php-app

## Build arm7hf image
build@arm7hf:
	sudo docker build . -f ./Dockerfile.arm7hf -t wolnosciowiec/docker-php-app:arm7hf
	sudo docker tag wolnosciowiec/docker-php-app:arm7hf quay.io/riotkit/php-app-arm

## Push x86_64 image to registry
push@x86_64:
	sudo docker push wolnosciowiec/docker-php-app

## Push arm7hf image to registry
push@arm7hf:
	sudo docker push wolnosciowiec/docker-php-app:arm7hf
