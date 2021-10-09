FROM jenkins/jenkins:alpine

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
    org.opencontainers.image.title="docker-suite dsuite/jenkins server image" \
    org.opencontainers.image.description="Ready to use alpine image with jenkins. For more info visit https://github.com/docker-suite/jenkins-setup" \
    org.opencontainers.image.authors="Hexosse <hexosse@gmail.com>" \
    org.opencontainers.image.vendor="docker-suite" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/docker-suite/jenkins" \
    org.opencontainers.image.source="https://github.com/docker-suite/jenkins" \
    org.opencontainers.image.documentation="https://github.com/docker-suite/jenkins/blob/master/Readme.md"

# Github token
ARG GH_TOKEN

## Switch to root user to perform install
USER root

## Install alpine-base and useful tools
RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk update \
    # Download the install-base script and run it
    && apk add --no-cache curl \
    && curl -s -o /tmp/install-base.sh https://raw.githubusercontent.com/docker-suite/Install-Scripts/master/alpine-base/install-base.sh \
    && sh /tmp/install-base.sh \
    # Add useful tools
    && apk-install \
        findutils \
        graphviz \
        make \
        sudo \
	# Clear apk's cache
	&& apk-cleanup

## Install default jenkins plugins use by groovy scripts
RUN \
    # Matrix Authorization Strategy: https://plugins.jenkins.io/matrix-auth
    jenkins-plugin-cli --plugins matrix-auth \
    # OWASP Markup Formatter: https://plugins.jenkins.io/antisamy-markup-formatter
    && jenkins-plugin-cli --plugins antisamy-markup-formatter \
    # OWASP Markup Formatter: https://plugins.jenkins.io/simple-theme-plugin
    && jenkins-plugin-cli --plugins simple-theme-plugin \
    # Badge: https://plugins.jenkins.io/badge
    && jenkins-plugin-cli --plugins badge \
    # Embeddable Build Status: https://plugins.jenkins.io/embeddable-build-status
    && jenkins-plugin-cli --plugins embeddable-build-status \
    # Docker plugin for Jenkins: https://plugins.jenkins.io/docker-plugin
    && jenkins-plugin-cli --plugins docker-plugin \
    # Docker Commons: https://plugins.jenkins.io/docker-commons
    && jenkins-plugin-cli --plugins docker-commons \
    # Docker Pipeline: https://plugins.jenkins.io/docker-workflow
    && jenkins-plugin-cli --plugins docker-workflow

## JVM options for running Jenkins.
ENV JAVA_OPTS "-Djava.util.logging.config.file=${REF}/logging.properties"

# Jenkins agent directory
# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
ARG JENKINS_AGENT_HOME=/var/jenkins_agent
ENV JENKINS_AGENT_HOME $JENKINS_AGENT_HOME
RUN mkdir -p $JENKINS_AGENT_HOME \
    && chown ${uid}:${gid} $JENKINS_AGENT_HOME

# Jenkins agent home directory is a volume, so agent workspace
# can be persisted and survive image upgrades
VOLUME $JENKINS_AGENT_HOME

## Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s CMD curl --fail 'http://localhost:${PORT}/login?from=login' || exit 1

## Copy root files to file system
COPY assets/rootfs /
COPY assets/ref ${REF}/

## Make entrypoint executable
RUN chmod +x entrypoint.sh

##
EXPOSE 8080 8081

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
