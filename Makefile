#!/usr/bin/env make

SUDO=sudo
SHELL=/bin/bash
.SILENT:
.PHONY: help
SLACK_URL=
LATEST_VERSION=7.3

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ## Build and push all versions
	EXIT_CODE=0; \
	for arch_path in $$(find ./dockerfile/src/versions/* -type d); do \
		ARCH=$$(basename $${arch_path}); \
		for file in $$(find $${arch_path}/*.json -type f); do \
			VERSION=$$(basename -s .json $${file}); \
			QEMU=true; \
			\
			if [[ "${ARCH}" == "x86_64" ]]; then \
				QEMU=false; \
			fi; \
			\
			make build VERSION=$${VERSION} ARCH=$${ARCH} QEMU=$${QEMU} || ./notify.sh "${SLACK_URL}" "Failed to build php-app:$${VERSION}-$${ARCH}" && EXIT_CODE=1; \
			make push VERSION=$${VERSION} ARCH=$${ARCH} || ./notify.sh "${SLACK_URL}" "Failed to push php-app:$${VERSION}-$${ARCH}" && EXIT_CODE=1; \
		done \
	done \
	\
	exit ${EXIT_CODE};

	make push_latest

build: ## Build a specific version (params: VERSION=7.3 ARCH=x86_64)
	echo " >> Building ${VERSION} for ${ARCH}"
	cat ./dockerfile/src/versions/${ARCH}/${VERSION}.json | j2 ./dockerfile/src/Dockerfile.j2 -f json  > ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile

	if [[ "${QEMU}" == "true" ]]; then \
		IMAGE=$$(jq '.FROM' ./dockerfile/src/versions/${ARCH}/${VERSION}.json); \
		make _inject_qemu IMAGE=$${IMAGE}; \
	fi

	${SUDO} docker build -t wolnosciowiec/docker-php-app:${VERSION}-${ARCH} -f ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile .
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:${VERSION}-${ARCH}

push: ## Push to a repository (params: VERSION=7.3 ARCH=x86_64)
	echo " >> Pushing ${VERSION} for ${ARCH}"
	${SUDO} docker push wolnosciowiec/docker-php-app:${VERSION}-${ARCH}
	${SUDO} docker push quay.io/riotkit/php-app:${VERSION}-${ARCH}

	./notify.sh "${SLACK_URL}" "Released php-app:${VERSION}-${ARCH} to the docker registry"

push_latest: ## Tag as latest, latest-stable and push
	echo " >> Pushing latest: ${LATEST_VERSION}"
	make _push_latest VERSION=${LATEST_VERSION} ARCH=x86_64
	make _push_latest VERSION=${LATEST_VERSION} ARCH=arm32v7

_inject_qemu:
	echo " >> Injecting qemu arm binaries into ${IMAGE}"
	${SUDO} docker rm -f tmp_php 2>/dev/null > /dev/null || true
	${SUDO} docker pull ${IMAGE}
	${SUDO} docker create --name tmp_php ${IMAGE}
	${SUDO} docker cp ./arm/usr tmp_php:/
	${SUDO} docker export tmp_php > /tmp/tmp_php.tar.gz
	cat /tmp/tmp_php.tar.gz | ${SUDO} docker import - ${IMAGE}
	rm /tmp/tmp_php.tar.gz
	${SUDO} docker rm -f tmp_php 2>/dev/null > /dev/null || true

_push_latest:
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:latest
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:latest-stable
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} wolnosciowiec/docker-php-app:latest
	${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} wolnosciowiec/docker-php-app:latest-stable

	${SUDO} docker push quay.io/riotkit/php-app:latest
	${SUDO} docker push quay.io/riotkit/php-app:latest-stable
	${SUDO} docker push wolnosciowiec/docker-php-app:latest
	${SUDO} docker push wolnosciowiec/docker-php-app:latest-stable
