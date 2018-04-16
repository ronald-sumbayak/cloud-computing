## Langkah-langkah menginstall Flask :
1. Buat file Dockerfile pada folder reservasi `nano Dockerfile`
2. Ketikkan perintah berikut :
	  ```FROM ubuntu:16.04
	  RUN apt-get update -y
	  RUN apt-get install -y python-pip python-dev build-essential
	  RUN apt-get install -y libmysqlclient-dev
	  COPY . /app
	  WORKDIR /app
	  RUN pip install -r req.txt
	  ENTRYPOINT ["python"]
	  CMD ["server.py"]
    ```
3. Simpan. Jalankan perintah `sudo docker build -t flask-sample:latest ./`
4. Jalankan perintah berikut `sudo docker run --name flask-ins -p 5000:5000 -d flask-sample:latest`
5. Cek container dengan perintah `sudo docker ps -a`
6. Jika status menampilkan "Up xx seconds", maka flask berhasil diinstall.
