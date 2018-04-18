FROM ubuntu:16.04
RUN apt-get update && apt-get -y install python-pip libmysqlclient-dev
RUN pip install --upgrade pip
ENV DB_HOST=192.168.0.24 \
    DB_NAME=reservasi \
    DB_USERNAME=userawan \
    DB_PASSWORD=buayakecil
COPY reservasi /reservasi
WORKDIR /reservasi
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["server.py"]
