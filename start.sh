#!/bin/bash

###
# script executed when container starts.  Performs configuration and setup of project.
###

printenv


### amend mysql passwords if branch != master ###
if [ "$BRANCH" != "master" ];
then

  echo "old password is $DB_ROOT_PARENT_PW"

  ### reset root mysql password
  mysql -u root -p$DB_ROOT_PARENT_PW -h $MYSQL_HOST -e "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"


  ### reset mysql password ###
  mysql -u root -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOST -e "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

fi

### blank out parent mysql password ###
export PARENT_MYSQL_PASSWORD="****"

### blank out parent mysql password ###
export MYSQL_ROOT_PASSWORD="****"

### grab latest code for the project and setup ###
wget -O /tmp/webapp.tar.gz https://s3-$AWS_REGION.amazonaws.com/$S3_URL
tar -xzf /tmp/webapp.tar.gz
rm /tmp/webapp.tar.gz
chown -Rf apache:apache /webapp

### create symlink for assets ###
ln -s /assets /webapp/sites/default/files
chown -Rf apache:apache /assets
chown -Rf apache:apache /webapp/sites/default/files

### check if container config file exists ###
if [ -f "/webapp/.container.yml" ];
then

  ### run ansible playbook ###
  ansible-playbook /playbook.yml  --connection=localhost

  ### remove ansible playbook when complete ###
  rm /webapp/.container.yml

fi

### start crond daemon ###
crond

### start apache2 ###
bash -c 'exec /usr/sbin/httpd -DFOREGROUND'
