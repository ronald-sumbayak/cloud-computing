#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install nginx php5 php5-fpm php5-cgi

sudo ln -s /vagrant/nginx.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo service php7.2-fpm start
sudo service nginx restart