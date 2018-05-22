# setting network
# sudo echo "nameserver 202.46.129.2" | sudo tee -a /etc/resolv.conf
# sudo cp /vagrant/interfaces /etc/network/interfaces
# sudo service networking restart

apt-get update
apt-get -y install python-software-properties
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get -y purge apache2
apt-get -y install nginx php7.2 php7.2-fpm php7.2-cgi php7.2-common php7.2-mysql php7.2-mbstring php7.2-xml php7.2-zip php7.2-pgsql composer zip

rm /etc/nginx/sites-enabled/default
ln -s /vagrant/codenote.conf /etc/nginx/sites-enabled
service nginx restart
service php7.2-fpm start

cd /var/www
git clone https://github.com/ronaldsumbayak/codenote -b cloud
chmod -R 777 codenote
cd codenote
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate

