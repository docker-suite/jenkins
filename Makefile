## Name of the image
DOCKER_IMAGE=dsuite/jenkins

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version
version = latest

## Config
.DEFAULT_GOAL := build
.PHONY: *


build:
	@docker build --no-cache \
		--file $(DIR)/Dockerfile \
		--tag $(DOCKER_IMAGE):$(version) \
		$(DIR)

push:
	@docker push $(DOCKER_IMAGE):$(version)

shell:
	@docker run -it --rm \
		--hostname=jenkins \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(version) \
		bash

remove:
	@if [ $(shell docker images -f "dangling=true" -q | wc -l) -gt 0 ]; then \
		docker rmi -f $(shell docker images -f "dangling=true" -q); \
	fi
	@docker image list --format "table {{.Repository}}:{{.Tag}}" | grep $(DOCKER_IMAGE):$(version) | xargs -I {} docker rmi $(DOCKER_IMAGE):$(version)

readme:
	@docker run -t --rm \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
