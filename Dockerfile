FROM gliderlabs/alpine:3.4

### install base components ###
RUN apk-install --no-cache curl bash jq tar rsync

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

### add ansible configuration file ###
COPY ansible.cfg /etc/ansible/ansible.cfg

### install postfix and dependencies ###
RUN apk-install postfix ca-certificates

### copy postfix config templates ###
COPY main.cf /tmp/main.cf
COPY sasl_passwd /tmp/sasl_passwd

### install openssh ###
RUN apk-install openssh

### copy opensshd config file ###
COPY sshd_config /etc/ssh/sshd_config

### create web user ###
RUN adduser web -s /bin/bash -D

### install python pip ###
RUN apk-install py-pip

### install passlib for ansible user module ###
RUN pip install passlib

### install shadow package for usermod ###
RUN apk-install shadow --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

### remove su binary ###
RUN rm /bin/su

### expore port 80 ###
EXPOSE 80 2222

### execute on start ###
CMD ["/bin/bash", "/start.sh"]
