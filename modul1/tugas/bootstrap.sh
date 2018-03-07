#!/usr/bin/env bash

####################################################################################################
# 1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'.

# create a new user 'awan' with password 'buayakecil'
 useradd \
    awan \
    -p $(echo buayakecil | openssl passwd -1 -stdin) \
    -d /home/awan6 -m

####################################################################################################

####################################################################################################
# one and for all

apt-get -y update
apt-get install -y python-software-properties  # for add-apt-repository
apt-get install -y language-pack-en-base
apt-get install -y zip unzip git

####################################################################################################

####################################################################################################
# 2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework

# fix locale warning for elixir
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales

# install Erlang/OTP platform and Elixir
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
apt-get install -y esl-erlang
apt-get install -y elixir
mix local.hex

# install Phoenix
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# create new Phoenix application (optional)
mix phx.new /home/vagrant/hello

####################################################################################################

####################################################################################################
# 3. Buat vagrant virtualbox dan lakukan provisioning install: php, mysql, composer, nginx

# install nginx
apt-get install -y nginx
service nginx start  # just in case
rm -f /etc/nginx/sites-enabled/*
cp /vagrant/pelatihan-laravel /etc/nginx/sites-available/pelatihan-laravel
ln -s /etc/nginx/sites-available/pelatihan-laravel /etc/nginx/sites-enabled
nginx -t
service nginx reload

# install php
sudo add-apt-repository ppa:ondrej/php
sudo apt-get install -y php7.1 php7.1-fpm php7.1-mysql php7.1-cli php7.1-zip php7.1-gd
sudo apt-get install -y mcrypt php7.1-mcrypt
sudo apt-get install -y php7.1-mbstring php7.1-xml --force-yes
sudo apt-get install -y php7.1-curl php7.1-json

# install mysql
apt-get install -y mysql-server 
mysql_install_db

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# configure project
sudo chown -R :www-data /var/www/laravel
sudo chmod -R 775 /var/www/laravel/storage

####################################################################################################

####################################################################################################
# 4. Buat vagrant virtualbox dan lakukan provisioning install: squid proxy, bind9

# install squid proxy
apt-get install -y squid

# install bind9
apt-get install -y bind9

####################################################################################################
