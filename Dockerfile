FROM gliderlabs/alpine:3.4

### install base components ###
RUN apk-install --no-cache curl bash jq tar

### install apache2, php5 and mysql-client ###
RUN  apk-install --no-cache apache2 php5-apache2 php5-cli php5-json php5-phar php5-openssl php5-ctype php5-pdo_mysql php5-gd php5-xml php5-pdo php5-dom php5-mysql php5-opcache

### create directories needed for apache ###
RUN mkdir -p /run/apache2

### add apache2 config file ###
ADD httpd.conf /etc/apache2/httpd.conf

### install composer and drush ###
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
    chmod +x /usr/local/bin/drush

### install mysql-client ###
RUN apk-install mysql-client

### install ansible ###
RUN apk-install ansible

### add start script ###
COPY start.sh /start.sh

### add ansible configuration playbook ###
COPY playbook.yml /playbook.yml

### install postfix and dependencies ###
RUN apk-install postfix ca-certificates

### copy postfix config templates ###
COPY main.cf /tmp/main.cf
COPY sasl_passwd /tmp/sasl_passwd

### expore port 80 ###
EXPOSE 80

### execute on start ###
CMD ["/bin/bash", "/start.sh"]
