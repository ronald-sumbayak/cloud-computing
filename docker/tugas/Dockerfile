FROM ubuntu:16.04
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y libmysqlclient-dev
COPY . /app
WORKDIR /app
RUN pip install -r req.txt
ENTRYPOINT ["python"]
CMD ["server.py"]
