#!/bin/bash

# grab latest code for the project and setup
wget -O /tmp/webapp.tar.gz https://s3-$AWS_REGION.amazonaws.com/$S3_URL
tar -xzf /tmp/webapp.tar.gz
rm /tmp/webapp.tar.gz
chown -Rf apache:apache /webapp

# create symlink for assets
ln -s /assets /webapp/sites/default/files
chown -Rf apache:apache /assets
chown -Rf apache:apache /app/sites/default/files

# start apache2
bash -c 'exec /usr/sbin/httpd -DFOREGROUND'
