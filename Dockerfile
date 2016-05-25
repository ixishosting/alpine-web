FROM gliderlabs/alpine:3.3

### install base components ###
RUN apk-install curl bash

### install apache2, php5 and mysql-client ###
RUN  apk-install apache2 php-apache2 php-cli php-json php-phar php-openssl php-ctype php-pdo_mysql php-gd php-xml php-pdo php-dom php-mysql php-opcache

### create directories needed for apache ###
RUN mkdir -p /run/apache2

### add apache2 config file ###
ADD httpd.conf /etc/apache2/httpd.conf

### install composer and drush ###
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
    chmod +x /usr/local/bin/drush

### install ansible ###
RUN apk add ansible --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted

### add start script ###
COPY start.sh /start.sh

### expore port 80 ###
EXPOSE 80

### execute on start ###
CMD ["/bin/bash", "/start.sh"]
