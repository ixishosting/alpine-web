#!/bin/sh

# clean app diretory to ensure clean start
if [ -d "/app" ]
then
    rm -rf /app
fi

# clone git repo and branch from environmental variables
git clone -b ${GIT_BRANCH} ${GIT_URL} /app

if [ ! -d "/app/sites/default/files" ]
then
    ln -s /assets /app/sites/default/files
fi

rm /app/docker-compose.yml rancher-compose.yml .drone.yml

chown -Rf apache:apache /assets

# start apache server in foreground mode
/usr/sbin/httpd -DFOREGROUND
