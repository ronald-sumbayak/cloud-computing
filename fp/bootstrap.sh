#!/usr/bin/env bash

apt-get update
apt-get -y install python-software-properties
apt-add-repository -y ppa:ondrej/php

apt-get update
apt-get -y install vagrant virtualbox nginx bind9 python-pip php7.2 php7.2-fpm php7.2-mysql

rm /etc/nginx/sites-enabled/default
ln -s /vagrant/tekankata.conf /etc/nginx/sites-enabled
service nginx restart
service php7.2-fpm start

mkdir /etc/bind/tekankata
cp /vagrant/tekankata.com /etc/bind/tekankata

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get -y install mysql-server libmysqlclient-dev
mysql -u root -proot -e /vagrant/tekankata.sql

pip install mysql-python

sudo -u vagrant crontab /vagrant/cronjob
