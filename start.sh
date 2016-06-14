#!/bin/bash

###
# script executed when container starts.  Performs configuration and setup of project.
###

echo "DEBUG:: CHECKING IF BRANCH IS NEW"

### amend mysql passwords if branch != master and this is a new commit/branch ###
if [ "$BRANCH" != "master" ] && [ "$IS_NEW" == "true" ];
then

  echo "DEBUG:: BRANCH IS MASTER AND IS NEW, SETTING PASSWORD"

  ### sleep to allow mysql to fully start ###
  sleep 5

  echo "old password is $DB_ROOT_PARENT_PW"

  echo "DEBUG:: SETTING ROOT PASSWORD"

  ### reset root mysql password
  mysql -u root -p$DB_ROOT_PARENT_PW -h $MYSQL_HOST -e "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

  echo "DEBUG:: SETTING USER PASSOWRD"

  ### reset mysql password ###
  mysql -u root -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOST -e "ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

fi

### blank out parent mysql password ###
export PARENT_MYSQL_PASSWORD="****"

### blank out parent mysql password ###
export MYSQL_ROOT_PASSWORD="****"

echo "DEBUG:: DOWNLOADING WEB BUILD"

### grab latest code for the project and setup ###
wget -O /tmp/webapp.tar.gz https://s3-$AWS_REGION.amazonaws.com/$S3_URL
tar -xvzf /tmp/webapp.tar.gz
#rm /tmp/webapp.tar.gz
chown -Rf nginx:nginx /webapp

echo "DEBUG:: CREATING ASSETS SYMLINK"

### create symlink for assets ###
ln -s /assets /webapp/sites/default/files
chown -Rf nginx:nginx /assets
chown -Rf nginx:nginx /webapp/sites/default/files

echo "DEBUG:: CHECKING IF ANIBLE PLAYBOOK EXISTS"

### check if container config file exists ###
if [ -f "/webapp/.container.yml" ];
then

echo "DEBUG:: EXECUTING PLAYBOOK"

  ### run ansible playbook ###
  ansible-playbook /playbook.yml  --connection=localhost

  ### remove ansible playbook when complete ###
  rm /webapp/.container.yml

fi

echo "DEBUG:: STARTING CRON"

### start crond daemon ###
crond

echo "DEBUG:: CLEARNING LOCK"

### release locks ###
#curl -sX PUT $API_ADDR/branch/$(curl -s $API_ADDR/branch/$ORG/$REPO/$BRANCH)/state/0

echo "DEBUG:: STARTING APACHE"

### start apache2 ###
#bash -c 'exec /usr/sbin/httpd -DFOREGROUND'
supervisord -c /etc/supervisor/conf.d/supervisord.conf