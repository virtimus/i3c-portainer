<p align="center">
  <img title="i3c.Cloud" width="155px" height="55px" src="https://raw.githubusercontent.com/virtimus/i3c/develop/assets/images/i3c-logo-black.svg?sanitize=true">
</p>

## Demo

You can quickly deploy current develop version inside a "play-with-docker" (PWD) playground:

- Browse [PWD/?stack=i3c-install/stack5.yml](http://play-with-docker.com/?stack=https://raw.githubusercontent.com/virtimus/i3c/develop/i3c-install/stack5.yml)
- Sign in with your [Docker ID](https://docs.docker.com/docker-id)
- Follow [these](https://raw.githubusercontent.com/virtimus/i3c/develop/i3c-install/stack5.yml) steps inside stack5.yml.


## Installation "from scratch" as full i3c.Cloud platform master node (local/bootstrap)
- For Windows you need first to build a Linux/Docker/Bash environment: 
    - install "Docker Toolbox" and "Bash on Ubuntu on Windows" (lxrun /install /yLinux) 
    - add host connection to bash profile (replacing "virtimus" with Your username and ip of docker host if needed):
    ```bash
    echo "export DOCKER_HOST='tcp://192.168.99.100:2376'" >> ~/.bashrc
    echo "export DOCKER_CERT_PATH='/mnt/c/Users/virtimus/.docker/machine/machines/default'" >> ~/.bashrc
    echo "export DOCKER_TLS_VERIFY=1" >> ~/.bashrc
    ```
    - run VirtualBox and add shared folder to "default" (docker host) machine: 
    c:/i3cRoot -> i3c -> automatic mount, persistent 
    - restart docker toolbox
    
- Next steps are common for Windows/Linux:    
- Make sure there are bash/git/curl/docker installed but no i3c* container is running (docker ps)
- Remove or backup /i3c root dir (or at least make it empty)
- You can create symbolic links for whole /i3c or /i3c/log and /i3c/data subfolders as they can grow big ....
ie (for BUOW):
```bash
ln -s /mnt/c/i3cRoot /i3c
```
- Run main bootstrap script:
```bash
curl -sSL https://raw.githubusercontent.com/virtimus/i3c/develop/bootstrap.sh | bash
```
- monitor installation progress:

```bash
tail -f /i3c/log/bootstrap.log
```

- at the end You should have container i3cd/i3c running (docker ps)
- backend i3c UI available at [hostIp]:9000 (localhost:9000 or 192.168.99.100:9000)


## Installation as local i3c.Cloud endpoint
... to be done
### Windows
...
### Linux
...
### Android
...
============================

<p align="center">
  <img title="portainer" src='https://portainer.io/images/logo_alt.png' />
</p>

[![Docker Pulls](https://img.shields.io/docker/pulls/portainer/portainer.svg)](https://hub.docker.com/r/portainer/portainer/)
[![Microbadger](https://images.microbadger.com/badges/image/portainer/portainer.svg)](http://microbadger.com/images/portainer/portainer "Image size")
[![Documentation Status](https://readthedocs.org/projects/portainer/badge/?version=stable)](http://portainer.readthedocs.io/en/stable/?badge=stable)
[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=portainer&repoName=portainer&branch=develop&pipelineName=portainer-ci&accountName=deviantony&type=cf-1)]( https://g.codefresh.io/repositories/portainer/portainer/builds?filter=trigger:build;branch:develop;service:5922a08a3a1aab000116fcc6~portainer-ci)
[![Code Climate](https://codeclimate.com/github/portainer/portainer/badges/gpa.svg)](https://codeclimate.com/github/portainer/portainer)
[![Slack](https://portainer.io/slack/badge.svg)](https://portainer.io/slack/)
[![Gitter](https://badges.gitter.im/portainer/Lobby.svg)](https://gitter.im/portainer/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YHXZJQNJQ36H6)

**_Portainer_** is a lightweight management UI which allows you to **easily** manage your different Docker environments (Docker hosts or Swarm clusters).

**_Portainer_** is meant to be as **simple** to deploy as it is to use. It consists of a single container that can run on any Docker engine (can be deployed as Linux container or a Windows native container).

**_Portainer_** allows you to manage your Docker containers, images, volumes, networks and more ! It is compatible with the *standalone Docker* engine and with *Docker Swarm mode*.

## Demo

<img src="https://portainer.io/images/screenshots/portainer.gif" width="77%"/>

You can try out the public demo instance: http://demo.portainer.io/ (login with the username **admin** and the password **tryportainer**).

Please note that the public demo cluster is **reset every 15min**.

Alternatively, you can deploy a copy of the demo stack inside a [play-with-docker (PWD)](https://labs.play-with-docker.com) playground:

- Browse [PWD/?stack=portainer-demo/play-with-docker/docker-stack.yml](http://play-with-docker.com/?stack=https://raw.githubusercontent.com/portainer/portainer-demo/master/play-with-docker/docker-stack.yml)
- Sign in with your [Docker ID](https://docs.docker.com/docker-id)
- Follow [these](https://github.com/portainer/portainer-demo/blob/master/play-with-docker/docker-stack.yml#L5-L8) steps.

Unlike the public demo, the playground sessions are deleted after 4 hours. Apart from that, all the settings are same, including default credentials.

## Getting started

* [Deploy Portainer](https://portainer.readthedocs.io/en/latest/deployment.html)
* [Documentation](https://portainer.readthedocs.io)

## Getting help

* Issues: https://github.com/portainer/portainer/issues
* FAQ: https://portainer.readthedocs.io/en/latest/faq.html
* Slack (chat): https://portainer.io/slack/
* Gitter (chat): https://gitter.im/portainer/Lobby

## Reporting bugs and contributing

* Want to report a bug or request a feature? Please open [an issue](https://github.com/portainer/portainer/issues/new).
* Want to help us build **_portainer_**? Follow our [contribution guidelines](https://portainer.readthedocs.io/en/latest/contribute.html) to build it  locally and make a pull request. We need all the help we can get!

## Limitations

**_Portainer_** has full support for the following Docker versions:

* Docker 1.10 to the latest version
* Docker Swarm >= 1.2.3

Partial support for the following Docker versions (some features may not be available):

* Docker 1.9
