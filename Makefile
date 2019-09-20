#!/usr/bin/env make

RIOTKIT_UTILS_VER=v2.0.0
SUDO=sudo
SHELL=/bin/bash
.SILENT:
.PHONY: help
SLACK_URL=
LATEST_VERSION=7.3

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build a specific version (params: VERSION=7.3 ARCH=x86_64)
	echo " >> Building ${VERSION} for ${ARCH}"
	cat ./dockerfile/src/versions/${ARCH}/${VERSION}.json | j2 ./dockerfile/src/Dockerfile.j2 -f json  > ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile

	if [[ "${QEMU}" == "true" ]]; then \
		IMAGE=$$(jq '.FROM' ./dockerfile/src/versions/${ARCH}/${VERSION}.json); \
		make _inject_qemu IMAGE=$${IMAGE}; \
	fi

	set -x; ${SUDO} docker build -t wolnosciowiec/docker-php-app:${VERSION}-${ARCH} -f ./dockerfile/build/${ARCH}/${VERSION}.Dockerfile .
	set -x ;${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:${VERSION}-${ARCH}
	set -x ;${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} quay.io/riotkit/php-app:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')
	set -x; ${SUDO} docker tag wolnosciowiec/docker-php-app:${VERSION}-${ARCH} wolnosciowiec/docker-php-app:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')

push: ## Push to a repository (params: VERSION=7.3 ARCH=x86_64)
	echo " >> Pushing ${VERSION} for ${ARCH}"
	${SUDO} docker push wolnosciowiec/docker-php-app:${VERSION}-${ARCH}
	${SUDO} docker push quay.io/riotkit/php-app:${VERSION}-${ARCH}

	${SUDO} docker push wolnosciowiec/docker-php-app:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')
	${SUDO} docker push quay.io/riotkit/php-app:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')

	./notify.sh "${SLACK_URL}" "Released php-app:${VERSION}-${ARCH} to the docker registry"


### COMMON AUTOMATION

dev@generate_travis_file: _download_tools ## Generate .travis.yml file
	export BUILDS=$$(./.helpers/collect-versions.py); \
	./.helpers/env-to-json parse_json | j2 ".travis.yml.j2" -f json > .travis.yml

dev@generate_readme: ## Renders the README.md from README.md.j2
	RIOTKIT_PATH=./.helpers DOCKERFILE_PATH=dockerfile/src/Dockerfile.j2 ./.helpers/docker-generate-readme

dev@before_commit: dev@generate_readme dev@generate_travis_file ## Git hook before commit
	git add README.md .travis.yml

dev@develop: ## Setup development environment, install git hooks
	echo " >> Setting up GIT hooks for development"
	mkdir -p .git/hooks
	echo "#\!/bin/bash" > .git/hooks/pre-commit
	echo "make dev@before_commit" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

_download_tools:
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/extract-envs-from-dockerfile > .helpers/extract-envs-from-dockerfile
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/env-to-json                  > .helpers/env-to-json
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/for-each-github-release      > .helpers/for-each-github-release
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/docker-generate-readme       > .helpers/docker-generate-readme
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/inject-qemu-bin-into-container > .helpers/inject-qemu-bin-into-container
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/setup-travis-arm-builds        > .helpers/setup-travis-arm-builds
	chmod +x .helpers/*

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
