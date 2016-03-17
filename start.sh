#!/bin/sh

# clone git repo and branch from environmental variables
git clone -b ${GIT_BRANCH} ${GIT_URL} /app

# setup symlink for assets
mkdir -p /app/sites/default/

if [ ! -d "/app/sites/default/files" ]
then
    ln -s /assets /app/sites/default/files
fi

chown -Rf apache:apache /assets

# start apache server in foreground mode
/usr/sbin/httpd -DFOREGROUND
