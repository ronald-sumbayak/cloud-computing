#!/usr/bin/env bash

apt-get update
service apache2 stop
apt-get -y install vagrant virtualbox

# install docker
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository -y 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'
apt-get update
apt-get -y install docker-ce

# cache required docker images
mkdir -p /vagrant/redzones/.docker_images
imgs=('wordpress:4.7.1 wordpress-4.7.1', 'mysql:5.7 mysql-5.7', 'phpmyadmin/phpmyadmin phpmyadmin')

cache_image () {
    docker pull $1 && docker save -o /vagrant/redzones/.docker_images/$2.tar.gz $1
}

for i in imgs; do
     cache_image $i
done

# install PHP
apt-get -y install python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get -y install php7.2 php7.2-fpm php7.2-mysql

# install nginx
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
ln -s /vagrant/tekankata.conf /etc/nginx/sites-enabled
service nginx restart
service php7.2-fpm start

# config bind9
apt-get -y install bind9
cp -f /vagrant/named.conf.local /etc/bind/tekankata
mkdir /etc/bind/tekankata
cp -f /vagrant/tekankata.com /etc/bind/tekankata
service bind9 restart

# install mysql
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get -y install mysql-server libmysqlclient-dev
mysql -u root -proot -e /vagrant/tekankata.sql

# install mysql connector for python
apt-get -y install python python-pip
pip install mysql-python

# add cronjob
sudo -u $USER crontab /vagrant/cronjob
