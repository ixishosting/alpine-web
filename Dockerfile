FROM gliderlabs/alpine:3.3

RUN apk-install php-apache2 curl php-cli php-json php-phar php-openssl php-ctype php-pdo_mysql php-gd php-xml php-pdo php-dom php-mysql php-opcache git openssh mysql-client rsync && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
chmod +x /usr/local/bin/drush && \
mkdir /run/apache2 && \
echo "Success"

ADD httpd.conf /etc/apache2/httpd.conf

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/start.sh"]
