## Load Balancing with Nginx
- [Soal](..)
- [Nomor 1](#1)
- [Nomor 2](#2)
- [Nomor 3](#3)

---

#### 1
**Buatlah Vagrantfile sekaligus provisioning-nya untuk menyelesaikan kasus.**

## Setup
- [Balancer](#balancer)
  - Box: [ubuntu/xenial64](https://app.vagrantup.com/ubuntu/boxes/xenial64)
  - IP: 192.168.0.2
  - [Vagrantfile](balancer/Vagrantfile)
  - [Provision](balancer/bootstrap.sh)
- [Workers](#workers)
  - Box: [ubuntu/xenial64](https://app.vagrantup.com/ubuntu/boxes/xenial64)
  - IP:
    - 192.168.0.3
    - 192.168.0.4
  - Vagrantfile
    - [Worker 1](workers/worker1/Vagrantfile)
    - [Worker 2](workers/worker2/Vagrantfile)
  - [Provision](workers/bootstrap.sh)

## TL;DR: How to Use

> Note: All features will work in assumes that the environments for balancer and workers are created by using the `load_balancing` and no commands entered directly into guest machine (no ssh required).

### Startup
```sh
./load_balancing start [balancing_method]
```

> Balancing method can be between **round_robin**, **ip_hash**, or **least_conn**.

Example:
```sh
./load_balancing start round_robin
./load_balancing start ip_hash
./load_balancing start least_conn
```

### Change Balancing Method
To change current balancing method, run:
```sh
./load_balancing method [balancing_method]
```

> Balancing method can be between **round_robin**, **ip_hash**, or **least_conn**.

Then reload the balancer machine.

Example
```sh
./load_balancing method round_robin
./load_balancing method ip_hash
./load_balancing method least_conn
```

### Destroy
To destroy currently active balancer and workers:
```sh
./load_balancing destroy
```

## Configuration

### Balancer
Balancer menggunakan konfigurasi vagrant sebagai berikut:

```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_check_update = false
  config.vm.network 'private_network', ip: '192.168.0.2'
  config.vm.provision 'shell', path: 'bootstrap.sh', privileged: false

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Tugas - Balancer'
    vb.memory = 512
    vb.cpus = 1
  end
end
```

dengan provision sebagai berikut:

```sh
sudo apt-get update
sudo apt-get -y install nginx

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /vagrant/balancer.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo service nginx restart
```

Provision akan meng-install nginx. Setelah itu me-link konfigurasi nginx (`balancer.conf`) yg berada pada folder `/vagrant` pada guest (directory yang sama dengan Vagrantfile pada host) ke directory `/etc/nginx/sites-enabled`.

> konfigurasi yang berada pada folder `/vagrant` adalah konfigurasi yang dipilih saat melakukan startup dengan executable `load_balancing`. ([more](#load_balancing))

### Workers
Setiap worker menggunakan konfigurasi vagrant sebagai berikut, dengan perbedaan pada ip yang digunakan:

```ruby
Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_check_update = false
  config.vm.network 'private_network', ip: '192.168.0.#'
  config.vm.provision 'shell', path: '../bootstrap.sh', privileged: false

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Tugas - Worker#'
    vb.memory = 512
    vb.cpus = 1
  end
end
```

dengan provision sebagai berikut:

```sh
sudo apt-get update
sudo apt-get -y install apache2
```

Dimana provisioning akan meng-install apache2 pada worker tanpa ada perubahan, sehingga worker akan men-serve Apache2 Ubuntu Default Page.

## load_balancing
`load_balancing` berisi script untuk meng-automasi proses startup, destroy, dan penggantian algoritma/method untuk load balancing pada balancer.

### Startup
```sh
./load_balancing start [balancing_method]
```

Perintah `start` akan meng-copy konfigurasi nginx pada directory [balancer/methods](balancer/methods) sesuai dengan balancing_method yang dipilih ke directory [balancer](balancer) dengan nama `balancer.conf`.

Kemudian menjalankan perintah `vagrant up` pada directory balancer dan workers.

Ada 3 method yang bisa dipilih, yaitu: **round_robin**, **ip_hash**, dan **least_conn**. Berikut masing-masing file konfigurasinya:

- round_robin:
  ```nginx
  upstream workers {
      server 192.168.0.3;
      server 192.168.0.4;
  }
  
  server {
      listen 80 default_server;
      listen [::]:80 default_server ipv6only=on;
      
      location / {
          proxy_pass http://workers;
      }
  }
  ```

- ip_hash:
  ```nginx
  upstream workers {
      ip_hash;
      server 192.168.0.3;
      server 192.168.0.4;
  }
  
  server {
      listen 80 default_server;
      listen [::]:80 default_server ipv6only=on;
      
      location / {
          proxy_pass http://workers;
      }
  }
  ```

- least_conn:
  ```nginx
  upstream workers {
      least_conn;
      server 192.168.0.3;
      server 192.168.0.4;
  }
  
  server {
      listen 80 default_server;
      listen [::]:80 default_server ipv6only=on;
      
      location / {
          proxy_pass http://workers;
      }
  }
  ```

### Change Balancing Method
```sh
./load_balancing method [balancing_method]
```

Perintah `method` akan meng-copy konfigurasi nginx pada directory [balancer/methods](balancer/methods) sesuai dengan balancing_method yang dipilih ke directory [balancer](balancer) dengan nama `balancer.conf`.

Karena file `balancer.conf` di-link ke directory `/etc/nginx/sites-enabled/balancer.conf`, maka file pada directory `/etc/nginx/sites-enabled/balancer.conf` juga akan otomatis berubah, sehingga hanya perlu me-restart service nginx atau me-reload machine balancer.

### Destroy
```sh
./load_balancing destroy
```

Perintah `destroy` akan menjalankan perintah `vagrant destroy --force` pada directory balancer dan workers.

---

#### 2
**Analisa apa perbedaan antara ketiga algoritma tersebut.**

### Round Robin
Membagi beban kerja secara berurutan dari satu server ke server lainnya. Konsep dasar dari algoritma ini adalah time sharing, yaitu membagikan beban kerja sesuai dengan antrian.
  
Misal ada 3 server yaitu A, B, C. Maka beban kerja akan dibagikan pada server A, lalu server B, selanjutnya server C, kembali lagi ke server A, dan begitu seterusnya sampai beban kerja habis dibagikan.

### Least Connection
Membagi beban kerja berdasarkan banyaknya koneksi yang sedang dilayani oleh sebuah server yang aktif. Algoritma penjadwalan ini termasuk dalam penjadwalan dinamik, dimana memerlukan perhitungan koneksi yang aktif untuk masing-masing real server. Algoritma ini baik digunakan untuk jaringan internet yang memerlukan throughput maksimal. Metode penjadwalan ini juga baik digunakan untuk melancarkan pendistribusian ketika request yang datang banyak.

Misal, ada 2 server yaitu A dan B. Koneksi aktif pada server A berjumlah 2 koneksi, sedangkan koneksi aktif pada server B berjumlah 1 koneksi, maka beban kerja akan diberikan kepada server B karena koneksi aktif server B lebih sedikit dibanding dengan server A.

### IP Hash
Menggunakan IP source dan destination dari klien dan server untuk men-generate hash key menjadi kode unik. Kode ini digunakan untuk mengalokasikan klien ke server tertentu. Metode ini dapat memastikan bahwa klien akan terhubung dengan server yang sama yang sebelumnya sudah terhubung. Metode ini sangat berguna untuk klien yang harus terhubung ke session yang masih aktif setelah terjadi diskoneksi atau rekoneksi.

---

#### 3
**Bagaimana mengatasi masalah session ketika kita melakukan load balancing?**

Dalam load balancing, dikenal sebuah metode/algoritma bernama Sticky Session. Pada sticky session, setelah session cookie telah dikeluarkan atau terbentuk, load balancer akan selalu mengarahkan permintaan dari klien yang terkait ke session, ke server yang sama tanpa mencari server baru lagi. Hal ini memungkinkan kita untuk menyimpan simpanan di sistem file lokal tanpa perlu sistem file yang dipakai bersama.
