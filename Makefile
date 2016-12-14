ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
THEME_DIR := $(ROOT_DIR)
THEME_NAME := "default-theme"

help:
	@echo "IPFS websites"
	@echo ""
	@echo "Usage:"
	@echo "  make deps             Makes sure you have dependencies installed"
	@echo "  make build            Builds a one-time build of the website"
	@echo "  make dev              Starts development server on port 1313"
	@echo "  make publish          Builds and publishes the website to ipld.io"
build-dep:
	@which hugo > /dev/null || (echo "You need to install hugo to build this website. See https://gohugo.io/" && exit 1)
publish-dep:
	@which ipfs > /dev/null || (echo "You need to install ipfs to publish this website. See https://ipfs.io/" && exit 1)
	@which dnslink-deploy > /dev/null || (echo "You need to install dnslink-deploy to publish this website. See https://github.com/ipfs/dnslink-deploy" && exit 1)
	@ipfs swarm peers > /dev/null || (echo "You need to run the IPFS daemon before publishing." && exit 1)
build: build-dep
	@echo "## Doing a one-time build of the website"
	@HUGO_THEMESDIR=$(THEME_DIR) hugo --theme=$(THEME_NAME)
dev: build-dep
	@echo "## Starts development server on port :1313"
	@HUGO_THEMESDIR=$(THEME_DIR) hugo server --theme=$(THEME_NAME)
publish: build-dep publish-dep build
	@echo "## Building & publishing website"
	@ipfs add -rq public | tail -n 1 > published-version

.PHONY: help deps build dev publish
