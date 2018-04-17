#!/usr/bin/env bash

# install php
sudo apt-get update
sudo apt-get -y install python-software-properties software-properties-common
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get -y install php7.2
sudo apt-get -y install php7.2-fpm php7.2-cgi

# install nginx
sudo apt-get -y --purge remove apache2
sudo apt-get -y install nginx

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /vagrant/nginx.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo service php7.2-fpm start
sudo service nginx restart
