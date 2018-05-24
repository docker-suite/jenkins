FROM jenkins/jenkins:alpine

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
      description="Minimal Alpine image used as a base image."

ARG USER_JENKINS=jenkins
ARG USER_ROOT=root
ARG GROUP_DOCKER=docker
ARG GROUP_DOCKER_GID=10001

ENV JENKINS_USER=admin
ENV JENKINS_PASS=password
ENV JENKINS_EXECUTORS=2

# Switch to root user
USER ${USER_ROOT}

# Create docker group and add user jenkins to the group
RUN addgroup -g ${GROUP_DOCKER_GID} ${GROUP_DOCKER} \
	&& addgroup ${USER_JENKINS} ${GROUP_DOCKER}

# Add user jenkins to list of sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install docker && alpine-base
RUN \
	# Print executed commands
	set -x \
    # Download the install script and run it
    && curl -s -o /tmp/install-base.sh https://raw.githubusercontent.com/craftdock/Install-Scripts/master/alpine-base/install-base.sh \
    && sh /tmp/install-base.sh \
    # Update repository indexes
    && apk update --update-cache \
    # Install docker and sudo
    && apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ docker sudo \
	# Clear apk's cache
	&& rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Switch to user jenkins
USER ${USER_JENKINS}

# Install default plugins
RUN install-plugins.sh \
    # Matrix Authorization Strategy: https://plugins.jenkins.io/matrix-auth
    matrix-auth \
    # OWASP Markup Formatter: https://plugins.jenkins.io/antisamy-markup-formatter
    antisamy-markup-formatter

# Copy fs files to file system
COPY fs/groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY fs/banner /
COPY fs/entrypoint /

# Entrypoint
ENTRYPOINT ["/entrypoint"]
