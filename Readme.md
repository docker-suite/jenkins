# jenkins

A [jenkins] docker image with docker socket and few plugins and groovy scripts to start.

## Features
- docker socket, so docker agent can be used
- default user from groovy script
- set number of executors from groovy script

## Environment variables
- JENKINS_ADMIN_USER : Name of the default user
- JENKINS_ADMIN_PASS : Password of the default user
- JENKINS_NB_EXECUTORS : number of executors

## How to use this image

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
