FROM gliderlabs/alpine:3.3

RUN apk-install php-apache2 curl php-cli php-json php-phar php-openssl php-ctype php-pdo_mysql php-gd php-xml php-pdo php-dom php-mysql php-opcache git openssh mysql-client rsync && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
wget -O /usr/local/bin/drush http://files.drush.org/drush.phar && \
chmod +x /usr/local/bin/drush && \
mkdir /app && chown -R apache:apache /app && \
sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/httpd.conf && \
sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
sed -i 's#/var/www/localhost/htdocs#/app#' /etc/apache2/httpd.conf && \
sed -i 's/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/g' /etc/apache2/httpd.conf && \
sed -i '/Require all granted/aRewriteEngine on' /etc/apache2/httpd.conf && \

mkdir /run/apache2 && \
echo "Success"

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/bin/sh", "/start.sh"]
