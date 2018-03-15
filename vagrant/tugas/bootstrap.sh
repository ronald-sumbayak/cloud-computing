#!/usr/bin/env bash

####################################################################################################
# 1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'

# create a new user 'awan' with password 'buayakecil'
 sudo useradd \
    awan \
    -p $(echo buayakecil | openssl passwd -1 -stdin) \
    -d /home/awan -m

####################################################################################################

####################################################################################################
# 2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework

# fix locale warning for elixir and add-apt-repository
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8

# install Erlang/OTP platform and Elixir
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get -y install esl-erlang elixir
mix local.hex --force
rm erlang-solutions_1.0_all.deb

# install nodejs
wget https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x64.tar.xz
tar xf node-v8.10.0-linux-x64.tar.xz
sudo mv -T node-v8.10.0-linux-x64 /usr/local/lib/nodejs
export PATH=$PATH:/usr/local/lib/nodejs/bin
echo export PATH=$PATH:/usr/local/lib/nodejs/bin >> ~/.bashrc
rm -r node-v8.10.0-linux-x64.tar.xz

# install Phoenix
mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
sudo apt-get -y install inotify-tools

# create new Phoenix application (beyond this point is optional)
echo Y | mix phx.new hello

cd hello
mix local.hex --force
mix deps.get
cd assets && npm install && node node_modules/brunch/bin/brunch build

cd ..
sudo apt-get -y install postgresql postgresql-contrib
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE hello_dev;"
sudo service postgresql restart
mix local.rebar --force
mix ecto.create

# mix phx.server

####################################################################################################

####################################################################################################
# 3. Buat vagrant virtualbox dan lakukan provisioning install: php, mysql, composer, nginx

# install php
sudo apt-get -y install python-software-properties software-properties-common
sudo apt-add-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get -y install php7.2
sudo apt-get -y install php7.2-fpm php7.2-cgi
sudo apt-get -y install php7.2-common php7.2-mysql php7.2-mbstring php7.2-xml
sudo apt-get -y install zip unzip

# install mysql
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<<  "mysql-server mysql-server/root_password_again password root"
sudo apt-get -y install mysql-server

# install composer (and laravel)
curl 'https://getcomposer.org/installer' | php
sudo mv composer.phar /usr/local/bin/composer
composer global require "laravel/installer"

# install nginx
sudo apt-get -y --purge remove apache2
sudo apt-get -y install nginx

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /vagrant/pelatihan-laravel.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo service php7.2-fpm start
sudo service nginx restart

# config project
cd /var/www/web
cp .env.example .env
composer install
php artisan key:generate

####################################################################################################

####################################################################################################
# 4. Buat vagrant virtualbox dan lakukan provisioning install: squid-proxy, bind9

# install squid-proxy
sudo apt-get -y install squid3

# install bind9
sudo apt-get -y install bind9

####################################################################################################

# clean up
sudo apt-get -y autoremove