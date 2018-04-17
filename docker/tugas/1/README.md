# Langkah-langkah menginstall Flask

1. Buat file [Dockerfile](../Dockerfile) pada folder reservasi `nano Dockerfile`
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
3. Simpan. Jalankan perintah `sudo docker build -t flask-sample:latest ./`
4. Jalankan perintah berikut `sudo docker run --name flask-ins -p 5000:5000 -d flask-sample:latest`
5. Cek container dengan perintah `sudo docker ps -a`
6. Jika status container menampilkan "Up xx seconds", maka flask berhasil diinstall.
