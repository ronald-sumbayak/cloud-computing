# Vagrant

- Box: [ubuntu/xenial64](https://app.vagrantup.com/ubuntu/boxes/xenial64)
- [Vagrantfile](#vagrantfile)
- [Provision](bootstrap.sh)

### [Vagrantfile](Vagrantfile)
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_check_update = false
  config.vm.network 'forwarded_port', guest: 80, host: 8080
  config.vm.network 'forwarded_port', guest: 3306, host: 6969
  config.vm.network 'forwarded_port', guest: 4000, host: 12000
  config.vm.network 'forwarded_port', guest: 8000, host: 16000
  config.vm.synced_folder 'pelatihan-laravel', '/var/www/web'
  config.vm.provision 'shell', path: 'bootstrap.sh', privileged: false

  config.vm.provider('virtualbox') do |vb|
    vb.memory = 512
    vb.cpus = 1
  end
end
```

### Soal
1. Buat vagrant virtualbox dan buat user 'awan' dengan password 'buayakecil'

    ```sh
    sudo useradd \
        awan \
        -p $(echo buayakecil | openssl passwd -1 -stdin) \
        -d /home/awan -m
    ```
    
    did it work?

    ![check_user_awan](assets/check_user_awan.png)

2. Buat vagrant virtualbox dan lakukan provisioning install Phoenix Web Framework

	Beberapa packages memerlukan config locale menggunakan UTF-8. Hal itu bisa dilakukan dengan:

	```sh
	locale-gen en_US.UTF-8
	sudo dpkg-reconfigure locales
	```
	
	Phoenix Web Framework ditulis menggunakan bahasa Elixir. Maka harus menginstall Elixir terlebih dahulu:

	```sh
	wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
	sudo dpkg -i erlang-solutions_1.0_all.deb
	sudo apt-get update
	sudo apt-get -y -f install esl-erlang elixir
	mix local.hex --force
	rm erlang-solutions_1.0_all.deb
	```

	Untuk package dependencies Phoenix menggunakan npm
	```sh
	wget https://nodejs.org/dist/v8.10.0/node-v8.10.0-linux-x64.tar.xz
	tar xf node-v8.10.0-linux-x64.tar.xz
	sudo mkdir /usr/local/lib/nodejs
	sudo mv node-v8.10.0-linux-x64 /usr/local/lib/nodejs/node-v8.10.0
	rm -r node-v8.10.0-linux-x64.tar.xz
	export NODE_HOME=/usr/local/lib/nodejs/node-v8.10.0
	export PATH=$NODE_HOME/bin:$PATH
	. ~/.profile
	```

	Install Phoenix Web Framework
	```
	mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
	```

	### Test Phoenix Web Framework
	Buat project baru
	```sh
	mix phx.new /home/vagrant/hello
	```

    Install assets dan dependencies
	```sh
	cd hello
	mix deps.get
	cd hello/assets
	npm install
	node node_modules/brunch/bin/brunch build
	```

	Setup database
	```sh
	cd ..
	sudo apt-get -y -f install postgresql postgresql-contrib
	sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
	sudo -u postgres psql -c "CREATE DATABASE hello_dev;"
	sudo service postgresql restart
	mix local.rebar --force
	mix ecto.create
	```

	Run server
	```sh
	mix phx.server
	```
	![check_phoenix_running](assets/check_phoenix_running.png)

	Pada vagrantfile sudah diset port forward dari 4000 guest ke 12000 host
	```ruby
	config.vm.network 'forwarded_port', guest: 4000, host: 12000
	```

	Hasil
	![check_phoenix](assets/check_phoenix.png)

3. Buat vagrant virtualbox dan lakukan provisioning install: php, mysql, composer, nginx
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

4. Buat vagrant virtualbox dan lakukan provisioning install: squid-proxy, bind9
Buka file bootsrap.sh, lalu tambahkan:
```sh
# install squid-proxy
sudo apt-get install -y -f squid

# install bind9
sudo apt-get install -y -f bind9
```
