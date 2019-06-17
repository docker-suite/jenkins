FROM jenkins/jenkins:alpine

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
      description="REady to use alpine image with jenkins." \
      vendor="docker-suite" \
      license="MIT"

ARG JENKINS_USER=jenkins
ARG ROOT_USER=root
ARG DOCKER_GROUP=docker
ARG DOCKER_GID=10001

ENV JENKINS_USER $JENKINS_USER
ENV JENKINS_HOME $JENKINS_HOME
ENV DOCKER_GROUP $DOCKER_GROUP

ENV JENKINS_ADMIN_USER=admin
ENV JENKINS_ADMIN_PASS=password
ENV JENKINS_NB_EXECUTORS=2

## Switch to root user
USER ${ROOT_USER}

## Create docker group and add user jenkins to the group
RUN addgroup -g ${DOCKER_GID} ${DOCKER_GROUP} \
	&& addgroup ${JENKINS_USER} ${DOCKER_GROUP}

## Add user jenkins to list of sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

## Install docker && alpine-base
RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk update \
    # Download the install-base script and run it
    && apk add curl \
    && curl -s -o /tmp/install-base.sh https://raw.githubusercontent.com/docker-suite/Install-Scripts/master/alpine-base/install-base.sh \
    && sh /tmp/install-base.sh \
    # Install docker and sudo
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        docker \ 
        sudo \
    # Add useful tools
    && apk-install \
        findutils \
	# Clear apk's cache
	&& apk-cleanup

## Switch to user jenkins
USER ${JENKINS_USER}

## Install default plugins
RUN install-plugins.sh \
    # Matrix Authorization Strategy: https://plugins.jenkins.io/matrix-auth
    matrix-auth \
    # OWASP Markup Formatter: https://plugins.jenkins.io/antisamy-markup-formatter
    antisamy-markup-formatter

## Copy root files to file system
COPY rootfs/groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY rootfs/banner /banner
COPY rootfs/entrypoint.sh /entrypoint.sh

# Make entrypoint executable
RUN sudo chmod +x entrypoint.sh

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]