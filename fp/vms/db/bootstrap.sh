#!/bin/bash

apt-get update
apt-get -y install postgresql postgresql-contrib

sudo -u postgres psql -c "CREATE DATABASE codenote;"
sudo -u postgres psql -c "CREATE USER cloud WITH PASSWORD 'cloud';"
sudo -u postgres psql -c "ALTER ROLE cloud SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE cloud SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE cloud SET TimeZone TO 'UTC';"
sudo -u postgres psql -c "GRANT ALL ON DATABASE codenote TO cloud;"

cp -R /vagrant/postgresql.conf /etc/postgresql/9.6/main
echo "host    all             all              0.0.0.0/0                       trust" >> /etc/postgresql/9.6/main/pg_hba.conf
echo "host    all             all              ::/0                            trust" >> /etc/postgresql/9.6/main/pg_hba.conf
/etc/init.d/postgresql restart
