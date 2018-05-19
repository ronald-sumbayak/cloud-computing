# Soal
1. Buat 3 VM, 2 Ubuntu 16.04 sebagai worker, 1 Debian 9 sebagai DB server
2. Pada vm Debian install Mysql dan setup agar koneksi DB bisa diremote dan memiliki user: username: regal password: bolaubi
3. Pada worker: 2.1. Install Nginx 2.2. Install PHP 7.2 2.3. Install composer 2.4. Install Git dan pastikan worker dapat menjalankan Laravel 5.6
4. Clone https://github.com/udinIMM/Hackathon pada setiap worker dan setup database pada .env mengarah ke DB server.
5. Setup root directory nginx ke folder Laravel hasil clone repo diatas

## Penyelesaian
### 1
Buat VM [worker1](../ansible/tugas/vms/workers/worker1/Vagrantfile), [worker2](../ansible/tugas/vms/workers/worker2/Vagrantfile), dan [db](../ansible/tugas/vms/db/Vagrantfile).

Buat file ```host```, lalu ketikkan perintah berikut (untuk grouping host)
```
[db]
10.11.1.2 ansible_user=vagrant

[workers]
10.11.1.3 ansible_user=vagrant
10.11.1.4 ansible_user=vagrant
```

Jalankan perintah
```
ansible -i ./hosts -m ping all -k
```

Jika status yang dihasilkan "SUCCESS" pada semua VM, maka berhasil.

---
### 2
Tambahkan role untuk db dan worker.

[db role](../tugas/roles/db/tasks/mysql.yml):

Buat file mysql.yml, lalu ketikkan perintah berikut
```
- name: Install mysql
  become: yes
  apt:
    name: "{{ item }}"
    update_cache: yes
  with_items:
    - mysql-server
    - python-mysqldb

- name: Copy mysql configuration file
  become: yes
  template:
    src: my.cnf
    dest: /etc/mysql/mariadb.conf.d/my.cnf

- name: restart service mysql
  become: yes
  systemd:
    name: mysql
    state: restarted

- name: Create user regal
  become: yes
  mysql_user:
    name: regal
    password: bolaubi
    host: '%'
    priv: '*.*:ALL'

- name: Create database hackathon
  become: yes
  mysql_db:
    name: hackathon
    encoding: utf8mb4
    collation: utf8mb4_unicode_ci
```

Buat file main.yml
```
- include: mysql.yml
```


wokers role:

Buat file laravel.yml
```
- name: Install git
  become: yes
  apt:
    name: git
    update_cache: yes

- name: Clone project
  become: yes
  git:
    repo: https://github.com/udinIMM/Hackathon
    dest: /var/www/Hackathon

- name: Copy laravel env file
  become: yes
  template:
    src: .env
    dest: /var/www/Hackathon/.env

- name: Change storage/ and bootstrap/cache/ permission
  become: yes
  file:
    path: "{{ item }}"
    mode: 0777
    recurse: yes
  with_items:
    - /var/www/Hackathon/storage
    - /var/www/Hackathon/bootstrap/cache

- name: Install project dependencies
  become: yes
  composer:
    command: install
    working_dir: /var/www/Hackathon

- name: Generate key
  become: yes
  shell: php artisan key:generate
  args:
    chdir: /var/www/Hackathon
```

Buat file nginx.yml
```
- name: Install nginx
  become: yes
  apt:
    name: nginx
    update_cache: yes

- name: Remove default nginx configuration file
  become: yes
  file:
    path: /etc/nginx/sites-enabled/default
    state: absent

- name: Copy nginx configuration file
  become: yes
  template:
    src: hackathon.conf
    dest: /etc/nginx/sites-enabled/hackathon.conf

- name: Restart service nginx
  become: yes
  service:
    name: nginx
    state: restarted
```

Buat file php.yml
```
- name: Add ppa:ondrej/php for PHP7.2
  become: yes
  apt_repository:
    repo: ppa:ondrej/php

- name: Install required PHP modules
  become: yes
  apt:
    name: "{{ item }}"
    update_cache: yes
  with_items:
    - php7.2
    - php7.2-fpm
    - php7.2-cgi
    - php7.2-common
    - php7.2-mysql
    - php7.2-mbstring
    - php7.2-xml
    - php7.2-zip
    - composer
    - zip
    - unzip

- name: Start service php7.2-fpm
  become: yes
  service:
    name: php7.2-fpm
    state: started
```

Buat file main.yml
```
- include: nginx.yml
- include: php.yml
- include: laravel.yml
```

Atur environment pada Laravel
```
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:rUSmIhQ2jp9bremjUuDeZz9wToEBOu0rJk8zuFdErCA=
APP_DEBUG=true
APP_LOG_LEVEL=debug
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=10.11.1.2
DB_PORT=3306
DB_DATABASE=hackathon
DB_USERNAME=regal
DB_PASSWORD=bolaubi

BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
```

Atur config pada template
```
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /var/www/Hackathon/public;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

migrate role:

Buat migrate.yml
```
- name: Migrate
  become: yes
  shell: php artisan migrate
  args:
    chdir: /var/www/Hackathon
```

Buat main.yml
```
- include: migrate.yml
```

tambah file playbook:

Buat site.yml
```
- hosts: db
  roles:
    - db

- hosts: workers
  roles:
    - workers

- hosts: 10.11.1.3
  roles:
    - migrate
```

simpan, lalu jalankan perintah
```
ansible-playbook -i hosts site.yml -k
```

---
### 3
Lihat pada worker1 10.11.1.3
![result3](assets/result3.png)

Lihat pada worker2 10.11.1.4
![result4](assets/result4.png)
