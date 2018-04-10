#!/usr/bin/env bash

# install nginx
sudo apt-get -y update
sudo apt-get -y install nginx

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /vagrant/balancer.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo service nginx restart
