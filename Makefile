#!/usr/bin/env make

SUDO=sudo
SHELL=/bin/bash
.SILENT:
.PHONY: help
SLACK_URL=

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build a specific version (params: VERSION=7.3 ARCH=x86_64)
	cat ./dockerfile/src/versions/${ARCH}/${VERSION}-${ARCH}.json | j2 ./dockerfile/src/Dockerfile.j2 -f json  > ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile
	${SUDO} docker build -t wolnosciowiec/docker-php-app:${VERSION}-${ARCH} -f ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile .
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:${VERSION}-${ARCH}

push: ## Push to a repository (params: VERSION=7.3 ARCH=x86_64)
	${SUDO} docker push wolnosciowiec/docker-php-app:${VERSION}-${ARCH}
	${SUDO} docker push quay.io/riotkit/php-app:${VERSION}-${ARCH}

	[[ "${SLACK_URL}" ]] && echo "{\"text\": \"Released php-app:${VERSION}-${ARCH} to the docker registry\"}" | curl -H 'Content-type: application/json' -d @- -X POST -s ${SLACK_URL};

build_all: build_55_x86_64 build_73_x86_64 build_72_x86_64 build_72_arm32v7 build_73_arm32v7 ## Build all versions

build_all_parallel: ## Build everything parallel
	make build_all -j$$(nproc)

push_all: push_55_x86_64 push_72_x86_64 push_73_x86_64 push_72_arm32v7 push_73_arm32v7 ## Push all versions

push_all_parallel: ## Push all versions parallel
	make push_all -j$$(nproc)

## BUILD

build_55_x86_64: ## -
	make build VERSION=5.5 ARCH=x86_64

build_73_x86_64: ## -
	make build VERSION=7.3 ARCH=x86_64

build_72_x86_64: ## -
	make build VERSION=7.2 ARCH=x86_64

build_72_arm32v7: ## -
	make build VERSION=7.3 ARCH=arm32v7

build_73_arm32v7: ## -
	make build VERSION=7.2 ARCH=arm32v7

## PUSH

push_55_x86_64: ## -
	make push VERSION=5.5 ARCH=x86_64

push_73_x86_64: ## -
	make push VERSION=7.3 ARCH=x86_64

push_72_x86_64: ## -
	make push VERSION=7.2 ARCH=x86_64

push_72_arm32v7: ## -
	make push VERSION=7.3 ARCH=arm32v7

push_73_arm32v7: ## -
	make push VERSION=7.2 ARCH=arm32v7