#!/bin/bash

# fix encoding warning for postgres
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

apt-get update
apt-get -y install postgresql postgresql-contrib

sudo -u postgres psql -c "CREATE DATABASE codenote;"
sudo -u postgres psql -c "CREATE USER cloud WITH PASSWORD 'cloud';"
sudo -u postgres psql -c "ALTER ROLE cloud SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE cloud SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE cloud SET TimeZone TO 'UTC';"
sudo -u postgres psql -c "GRANT ALL ON DATABASE codenote TO cloud;"

cp -R /vagrant/postgresql.conf /etc/postgresql/9.6/main
echo "host  all  all  0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf
echo "host  all  all  ::/0       md5" >> /etc/postgresql/9.6/main/pg_hba.conf
/etc/init.d/postgresql restart
