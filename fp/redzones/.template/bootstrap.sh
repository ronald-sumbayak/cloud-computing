#!/usr/bin/env bash

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

apt-get update
apt-get -y install docker docker-compose

git clone https://github.com/ndemoor/docker-wordpress-workflow-demo.git wpdc
cd wpdc
docker-compose up -d
