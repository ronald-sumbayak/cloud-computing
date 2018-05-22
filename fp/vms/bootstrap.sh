#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install ansible sshpass

cat /home/vagrant/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys
