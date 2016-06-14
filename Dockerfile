FROM gliderlabs/alpine:latest

# Install packages
RUN apk --update add ca-certificates openssl curl bash php7 php7-fpm php7-pdo_mysql php7-phar php7-opcache php7-mcrypt php7-gd php7-mysqlnd php7-openssl nginx supervisor --repository http://nl.alpinelinux.org/alpine/edge/testing/

# Configure nginx
RUN mkdir /run/nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

### install composer and drush ###
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
#    wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
#    chmod +x /usr/local/bin/drush

### install mysql-client ###
RUN apk-install --no-cache mysql-client

### install ansible ###
RUN apk add --no-cache ansible --repository http://dl-3.alpinelinux.org/alpine/edge/main/ --allow-untrusted

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

### add start script ###
COPY start.sh /start.sh

### add ansible configuration playbook ###
COPY playbook.yml /playbook.yml

### expore port 80 ###
EXPOSE 80

# Add application
RUN mkdir -p /var/www/html

WORKDIR /

EXPOSE 80 443

### execute on start ###
CMD ["/bin/bash", "/start.sh"]
