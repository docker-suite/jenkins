# ![](https://github.com/docker-suite/artwork/raw/master/logo/png/logo_32.png) jenkins
[![Build Status](http://jenkins.hexocube.fr/job/docker-suite/job/jenkins/badge/icon?color=green&style=flat-square)](http://jenkins.hexocube.fr/job/docker-suite/job/jenkins/)
![Docker Pulls](https://img.shields.io/docker/pulls/dsuite/jenkins.svg?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/dsuite/jenkins.svg?style=flat-square)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/dsuite/jenkins/latest.svg?style=flat-square)
![MicroBadger Size (tag)](https://img.shields.io/microbadger/image-size/dsuite/jenkins/latest.svg?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A customized [jenkins] container ready to use with preinstalled plugins and customs groovy scripts. 


## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Groovy scripts

- crsf protection
- disabled CLI remoting
- disable old agent protocol
- enabling slave master access control
- define the number of executors (default to 0).
- create a default admin user `jenkins`.
- prevent anonymous users to have read access.
- custom theme.


## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Environment variables

- JENKINS_NB_EXECUTORS : number of executors
- JENKINS_ADMIN_PASS : Password for `jenkins` user


## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) How to use this image

> For a complete Jenkins setup, look at [jenkins setup][jenkins-setup]


[jenkins]: https://jenkins.io/
[jenkins-setup]: https://github.com/docker-suite/jenkins-setup/
