# How to Run

```sh
docker-compose up
```

# 1
1. Buat file [Dockerfile](Dockerfile) pada folder reservasi `nano Dockerfile`
2. Ketikkan perintah berikut :
    ```Dockerfile
    FROM ubuntu:16.04
    RUN apt-get update && apt-get -y install python-pip libmysqlclient-dev
    COPY reservasi /reservasi
    WORKDIR /reservasi
    RUN pip install -r requirements.txt
    ENTRYPOINT ["python"]
    CMD ["server.py"]
    ```
3. Simpan. Jalankan perintah `sudo docker build -t reservasi .`.
4. Cek container dengan perintah `sudo docker ps`.

# 2
1. Buat file [docker-compose.yml](docker-compose.yml) pada folder dimana Dockerfile dibuat.
2. Buat 3 buah worker dengan menggunakan image yang dibuat pada soal [1](#1).
```yml
services:
    worker1:
        image: reservasi
    worker2:
        image: reservasi
    worker3:
        image: reservasi
```

# 3
1. Tambahkan service untuk load balancer pada file docker-compose.yml
```yml
balancer:
    image: nginx
    depends_on:
        - worker1
        - worker2
        - worker3
    ports:
        - 5000:80
    volumes:
        - ./balancer.conf:/etc/nginx/conf.d/default.conf
```
Keterangan:
- `depends_on`
  Balancer akan menunggu sampai semua worker sudah berjalan baru balancer dimulai.
- `ports`
  Port mapping dari port 80 container ke port 5000 host
- `volumes`
  Mount file [balancer.conf](balancer.conf) ke directory `/etc/nginx/conf.d` pada container dimana nginx akan meng-include config server.

2. Tambahkan docker networks pada compose file agar balancer dan workers berada pada satu network.
```yml
networks:
    reservasi:
        ipam:
            config:
                - subnet: 192.168.0.0/24
```

3. Berikan static IP pada balancer dan workers.
```yml
services:
    worker1:
        networks:
            reservasi:
                ipv4_address: 192.168.0.21
    worker2:
        networks:
            reservasi:
                ipv4_address: 192.168.0.22
    worker3:
        networks:
            reservasi:
                ipv4_address: 192.168.0.23
    balancer:
        networks:
            reservasi:
                ipv4_address: 192.168.0.25
```

# 4
1. Tambahkan setup db untuk worker dan setup db pada file docker-compose.yml.
setup db untuk worker1, worker2, worker3
```yml
   depends_on:
        - db
   environment:
        DB_HOST: 192.168.0.24
        DB_NAME: reservasi
        DB_USERNAME: userawan
        DB_PASSWORD: buayakecil
```
setup db
```yml
   db:
        container_name: reservasi-db
        image: mysql
        environment:
            MYSQL_ROOT_PASSWORD: root
            MYSQL_DATABASE: reservasi
            MYSQL_USER: userawan
            MYSQL_PASSWORD: buayakecil
        volumes:
            - ./.mysql_data:/var/lib/mysql
            - ./reservasi/reservasi.sql:/docker-entrypoint-initdb.d/reservasi.sql
        networks:
            reservasi:
                ipv4_address: 192.168.0.24
```
Complete file : [docker-compose.yml](docker-compose.yml)

2. Simpan. Jalankan perintah `sudo docker-compose up -d`. Untuk mengecek kontainer yang berjalan, jalankan perintah `sudo docker-compose images`.

3. Cek pada browser dengan memasukkan `localhost:5000`.
