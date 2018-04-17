FROM ubuntu:16.04
RUN apt-get update && apt-get -y install python-pip libmysqlclient-dev
COPY ../reservasi /reservasi
WORKDIR /reservasi
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["server.py"]
