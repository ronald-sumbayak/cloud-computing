# cloud-computing
[KI141406] Cloud Computing

[Komputasi Awan – Vagrant]

1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'.
- Buat file provisioning terlebih dahulu. Dalam pengerjaan ini, kami memasukkan perintah:
	nano bootstrap.sh				
- Masukkan syntax untuk membuat user “awan” dan password “buayakecil” :
  sudo useradd \
  awan \
  -p $(echo buayakecil | openssl passwd -1 -stdin) \
  -d /home/awan -m

- Simpan file bootstrap.sh

- Jalankan perintah :
	vagrant provision
	vagrant up
	vagrant ssh

- Lalu masukkan perintah untuk login menggunakan user "awan:
	su - awan
	(masukkan password= buayakecil)

2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework
- Buka file bootstrap.sh, lalu tambahkan perintah untuk menginstall Erlang/OTP platform (bahasa) dan Phoenix:
	# fix locale warning for elixir and add-apt-repository
	locale-gen en_US.UTF-8
	sudo dpkg-reconfigure locales
	# install Erlang/OTP platform and Elixir
	wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
	sudo dpkg -i erlang-solutions_1.0_all.deb
	sudo apt-get update
	sudo apt-get -y -f install esl-erlang elixir
	mix local.hex --force
	rm erlang-solutions_1.0_all.deb
	# install Phoenix
	mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

- Simpan file bootstrap.sh

- Jalankan perintah :
	vagrant provision
	vagrant up
	vagrant ssh

- Untuk memulai membuat project, ketikkan perintah:
	# create new Phoenix application (beyond this point is optional)
	mix phx.new /home/vagrant/hello

	cd /home/vagrant/hello
	mix local.hex --force
	mix deps.get

	cd assets
	wget https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x64.tar.xz
	tar xf node-v8.10.0-linux-x64.tar.xz
	sudo mkdir /usr/local/lib/nodejs
	sudo mv node-v8.10.0-linux-x64 /usr/local/lib/nodejs/node-v8.10.0
	rm -r node-v8.10.0-linux-x64.tar.xz
	export NODE_HOME=/usr/local/lib/nodejs/node-v8.10.0
	export PATH=$NODE_HOME/bin:$PATH
	. ~/.profile
	npm install
	node node_modules/brunch/bin/brunch build

	cd ..
	sudo apt-get -y -f install postgresql postgresql-contrib
	sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
	sudo -u postgres psql -c "CREATE DATABASE hello_dev;"
	sudo service postgresql restart
	mix local.rebar --force
	mix ecto.create
	# mix phx.server

3. Buat vagrant virtualbox dan lakukan provisioning install:
		1.	php
		2.	mysql
		3.	composer
		4.	nginx
		setelah melakukan provioning, clone https://github.com/fathoniadi/pelatihan-laravel.git pada 	folder yang sama dengan vagrantfile di komputer host. Setelah itu sinkronisasi folder 	pelatihan-laravel host ke vagrant ke /var/www/web dan jangan lupa install vendor laravel 	agar dapat dijalankan. Setelah itu setting root document nginx ke /var/www/web. webserver 	VM harus dapat diakses pada port 8080 komputer host dan mysql pada vm dapat diakses 	pada port 6969 komputer host.		
		----------
		#4 Install NGINX
- Buka file bootstrap.sh, lalu tambahkan perintah berikut untuk menginstall Nginx:
	# install nginx
	sudo apt-get install -y -f nginx
	service nginx start

- Simpan file bootstrap.sh

- Jalankan perintah :
	vagrant provision
	vagrant up
	vagrant ssh

- Untuk memastikan apakah nginx sudah terinstall, buka localhost:port pada browser. Jika muncul kalimat "Welcome to nginx!", berarti nginx berhasil terinstall
	
4. Buat vagrant virtualbox dan lakukan provisioning install:
    1.	Squid proxy
    2.	Bind9
		
- Buka file bootsrap.sh, lalu ketikkan perintah berikut untuk menginstall Squid proxy dan Bind9:
	# install squid proxy
	apt-get install -y -f squid
	# install bind9
	apt-get install -y -f bind9

- Simpan file bootstrap.sh

- Jalankan perintah :
	vagrant provision
