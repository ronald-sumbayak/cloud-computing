# setting network
sudo echo "nameserver 202.46.129.2" | sudo tee -a /etc/resolv.conf
sudo cp interfaces /etc/network/interfaces
sudo service networking restart

sudo apt-get update
sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get -y install nginx php5.6 composer
