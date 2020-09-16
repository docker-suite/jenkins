## Name of the image
DOCKER_IMAGE=dsuite/jenkins

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

.PHONY: *

build:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--build-arg no_proxy=${no_proxy} \
		--build-arg GH_TOKEN=${GH_TOKEN} \
		--file $(DIR)/Dockerfile \
		--tag $(DOCKER_IMAGE):latest \
		$(DIR)/.

test: build
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e no_proxy=${no_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run $(DOCKER_IMAGE):latest

push: build
	@docker push $(DOCKER_IMAGE):latest

run: build
	@mkdir -p $(DIR)/.jenkins
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e no_proxy=${no_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e TIMEZONE=Europe/Paris \
		-e JENKINS_USER=hexosse \
		-e JENKINS_PASS=password \
		-e JENKINS_EXECUTORS=5 \
		-e JENKINS_URL=http://localhost:8080 \
		-e JAVA_OPTS="-Dhudson.footerURL=http://myjenkins.com" \
		-v $(DIR)/.jenkins:/var/jenkins_home \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-p 8080:8080 \
		-p 50000:50000 \
		$(DOCKER_IMAGE):latest

remove:
	@rm -rf $(DIR)/.jenkins
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

readme:
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e no_proxy=${no_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
