#!/usr/bin/env bash

 sudo useradd \
    cloud \
    -p $(echo "raincloud123!" | openssl passwd -1 -stdin) \
    -d /home/cloud -m

sudo apt-get -y update
sudo apt-get -y install ansible sshpass

cat /home/vagrant/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys