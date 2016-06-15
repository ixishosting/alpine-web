FROM gliderlabs/alpine:3.4

# Install packages
RUN apk add --no-cache ansible mysql-client nginx bash curl supervisor ca-certificates openssl && \
  apk add --no-cache php5 php5-fpm php5-pdo_mysql php5-json -php5-opcache php5-mcrypt php5-gd php5-openssl

### install composer and drush ###
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
    chmod +x /usr/local/bin/drush

# Configure nginx
RUN mkdir /run/nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

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
