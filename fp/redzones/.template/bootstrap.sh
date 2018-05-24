#!/usr/bin/env bash

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

apt-get update
apt-get -y install docker docker-compose

imgs=(wordpress-4.7.1.tar.gz mysql-5.7.tar.gz phpmyadmin.tar.gz)
for i in imgs; do
    docker load -i docker_images/$i
done

git clone https://github.com/ndemoor/docker-wordpress-workflow-demo.git wpdc
cd wpdc
docker-compose up -d
