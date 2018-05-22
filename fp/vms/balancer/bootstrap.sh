#!/bin/bash

# setting network
#sudo echo "nameserver 202.46.129.2" | sudo tee -a /etc/resolv.conf
#sudo cp /vagrant/interfaces /etc/network/interfaces
#sudo service networking restart

apt-get update
apt-get -y purge apache2
apt-get -y install nginx bind9
service nginx restart

rm /etc/nginx/sites-enabled/default
ln -s /vagrant/codenote.conf /etc/nginx/sites-enabled
