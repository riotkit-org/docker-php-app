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

	if [[ "${QEMU}" == "TRUE" ]]; then \
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

	./.helpers/notify.sh "${SLACK_URL}" "Released php-app:${VERSION}-${ARCH} to the docker registry"

dev@build_all: _download_tools ## Build locally all possible versions
	export BUILDS=$$(./.helpers/collect-versions.py); \
	./.helpers/current/env-to-json parse_json | j2 "./.helpers/test-all-versions.sh.j2" -f json > ./.helpers/test-all-versions.sh
	chmod +x ./.helpers/test-all-versions.sh
	./.helpers/test-all-versions.sh
	rm test-all-versions.sh

### COMMON AUTOMATION

dev@generate_travis_file: _download_tools ## Generate .travis.yml file
	export BUILDS=$$(./.helpers/collect-versions.py); \
	./.helpers/current/env-to-json parse_json | j2 ".travis.yml.j2" -f json > .travis.yml

dev@generate_readme: _download_tools ## Renders the README.md from README.md.j2
	RIOTKIT_PATH=./.helpers/current DOCKERFILE_PATH=dockerfile/src/Dockerfile.j2 ./.helpers/current/docker-generate-readme

dev@before_commit: dev@generate_readme dev@generate_travis_file ## Git hook before commit
	git add README.md .travis.yml

dev@develop: _download_tools ## Setup development environment, install git hooks
	echo " >> Setting up GIT hooks for development"
	mkdir -p .git/hooks
	echo "#\!/bin/bash" > .git/hooks/pre-commit
	echo "make dev@before_commit" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

_download_tools:
	if [[ ! -d ".helpers/${RIOTKIT_UTILS_VER}" ]]; then \
		mkdir -p .helpers/${RIOTKIT_UTILS_VER}; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/extract-envs-from-dockerfile > .helpers/${RIOTKIT_UTILS_VER}/extract-envs-from-dockerfile; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/env-to-json                  > .helpers/${RIOTKIT_UTILS_VER}/env-to-json; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/for-each-github-release      > .helpers/${RIOTKIT_UTILS_VER}/for-each-github-release; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/docker-generate-readme       > .helpers/${RIOTKIT_UTILS_VER}/docker-generate-readme; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/inject-qemu-bin-into-container > .helpers/${RIOTKIT_UTILS_VER}/inject-qemu-bin-into-container; \
		curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/setup-travis-arm-builds        > .helpers/${RIOTKIT_UTILS_VER}/setup-travis-arm-builds; \
	fi

	rm -f .helpers/current
	ln -s $$(pwd)/.helpers/${RIOTKIT_UTILS_VER} $$(pwd)/.helpers/current
	chmod +x .helpers/*/*

_inject_qemu: _download_tools
	./.helpers/current/inject-qemu-bin-into-container ${IMAGE}
