#!/bin/bash

apt-get update
apt-get -y install bind9

cp -f /vagrant/named.conf.local /etc/bind
mkdir /etc/bind/tcodenote
cp -f /vagrant/tcodenote.com /etc/bind/tcodenote
service bind9 restart
