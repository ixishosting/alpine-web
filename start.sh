#!/bin/bash

###
# script executed when container starts.  Performs configuration and setup of project.
###

### grab latest code for the project and setup ###
wget -O /tmp/webapp.tar.gz https://s3-$AWS_REGION.amazonaws.com/$S3_URL
tar -xzf /tmp/webapp.tar.gz
rm /tmp/webapp.tar.gz
chown -Rf apache:apache /webapp

### create symlink for assets ###
ln -s /assets /webapp/sites/default/files
chown -Rf apache:apache /assets
chown -Rf apache:apache /webapp/sites/default/files

### check if project config file exists ###
if [ -f "/webapp/.project.yml" ];
then

  ### run ansible playbook ###
  ansible-playbook /webapp/.project.yml  --connection=localhost

  ### remove ansible playbook when complete ###
  rm /webapp/.project.yml

fi

### start apache2 ###
bash -c 'exec /usr/sbin/httpd -DFOREGROUND'
