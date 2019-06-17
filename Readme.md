# ![](https://github.com/docker-suite/artwork/raw/master/logo/png/logo_32.png) jenkins
[![Build Status](http://jenkins.hexocube.fr/job/docker-suite/job/jenkins/badge/icon?color=green&style=flat-square)](http://jenkins.hexocube.fr/job/docker-suite/job/jenkins/)
![Docker Pulls](https://img.shields.io/docker/pulls/dsuite/jenkins.svg?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/dsuite/jenkins.svg?style=flat-square)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/dsuite/jenkins/latest.svg?style=flat-square)
![MicroBadger Size (tag)](https://img.shields.io/microbadger/image-size/dsuite/jenkins/latest.svg?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A [jenkins] docker image built on top of the latest [Alpine base][alpine-base] container with docker socket and few plugins and groovy scripts to start.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Features
- docker socket, so docker agent can be used
- default user from groovy script
- set number of executors from groovy script

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Environment variables
- JENKINS_ADMIN_USER : Name of the default user
- JENKINS_ADMIN_PASS : Password of the default user
- JENKINS_NB_EXECUTORS : number of executors

> More environment variables from [Alpine base](https://github.com/docker-suite/alpine-base/#-environment-variables)

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) How to use this image

```bash
docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ./.jenkins:/var/jenkins_home \
    -p 8080:8080 \
    -p 50000:50000 \
    craftdock/jenkins
```

```bash
docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ./.jenkins:/var/jenkins_home \
    -e JENKINS_ADMIN_USER=admin \
    -e JENKINS_ADMIN_PASS=password \
    -e JENKINS_NB_EXECUTORS=5 \
    -e JENKINS_URL=http://localhost:8080 \
    -p 8080:8080 \
    -p 50000:50000 \
    craftdock/jenkins
```

[jenkins]: https://jenkins.io/
[alpine-base]: https://github.com/docker-suite/alpine-base/
