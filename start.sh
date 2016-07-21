#!/bin/bash

###
# script executed when container starts.  Performs configuration and setup of project.
###

### get current and parent root passwords ###
export PARENT_MYSQL_ROOT_PASSWORD=$(curl -sX GET --header "token:$API_TOKEN" $API_ADDR/secrets/$BRANCH/$REPO/$ORG | jq '.db_pw_root_parent' | sed 's/\"//g')
export MYSQL_ROOT_PASSWORD=$(curl -sX GET --header "token:$API_TOKEN" $API_ADDR/secrets/$BRANCH/$REPO/$ORG | jq '.db_pw_root' | sed 's/\"//g')

echo "parent password"
echo $PARENT_MYSQL_ROOT_PASSWORD
echo "root password"
echo $MYSQL_ROOT_PASSWORD

### test mysql connection ###
echo "DEBUG :: TESTING MYSQL CONNECTION"
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST  --connect-timeout=5 -e 'show databases;'
MYSQL_SUCCESS=$?

### if mysql connection failure ###
if [ $MYSQL_SUCCESS -ne 0 ]; then

  echo "DEBUG :: MYSQL CONNECTION FAILURE"
  ### reset root and user passwords ###
  mysql -u root -p$PARENT_MYSQL_ROOT_PASSWORD -h $MYSQL_HOST -e "ALTER USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
  mysql -u root -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOST -e "ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
  echo "DEBUG :: MYSQL CONNECTION DETAILS UPDATED"

else

  echo "DEBUG :: MYSQL CONNECTION SUCCESS - NOWT TO DO"

fi

echo "DEBUG:: RUNNING ANSIBLE"

### run ansible playbook ###
ansible-playbook /playbook.yml  --connection=localhost

echo "DEBUG:: STARTING CRON"

### start crond daemon ###
crond -b

echo "DEBUG:: CLEARNING LOCK"

### release locks ###
curl -sX PUT --header "token:$API_TOKEN" $API_ADDR/branch/$(curl -s $API_ADDR/branch/$ORG/$REPO/$BRANCH)/state/0

echo "DEBUG:: STARTING APACHE"

### start apache2 ###
bash -c 'exec /usr/sbin/httpd -DFOREGROUND'
