FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apache2 php7.0 php7.0-fpm libapache2-mod-php && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY www/index.php /var/www/html

WORKDIR /var/www/html
RUN rm index.html

WORKDIR /

CMD ["apachectl", "-D", "FOREGROUND"]

EXPOSE 80
