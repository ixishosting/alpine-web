#!/bin/sh

# grab latest code for project, extract and sym-link to app directory

cd /tmp/
wget -O webapp.tar.gz https://s3-$AWS_REGION.amazonaws.com/$S3_URL
tar xzf webapp.tar.gz
rm webapp.tar.gz
ln -s /tmp/webapp /app
chown -Rf apache:apache /app/

# setup assets symlink

if [ ! -d "/app/sites/default/files" ]
then
    ln -s /assets /app/sites/default/files
fi

chown -Rf apache:apache /assets
chown -Rf apache:apache /app/sites/default/files

# start apache server in foreground mode
/usr/sbin/httpd -DFOREGROUND
