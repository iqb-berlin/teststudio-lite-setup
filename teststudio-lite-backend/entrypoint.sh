#!/usr/bin/env bash

# db connection
DBConnectionDataFile=/var/www/html/vo_code/DBConnectionData.json

## delete sample config file
checkSum=$(cksum $DBConnectionDataFile | awk -F" " '{print $1}')
if [[ "$checkSum" -eq  "1486529974" ]]; then
  echo "delete sample config file"
  rm $DBConnectionDataFile
fi

## create new one

if [[ ! -f "$DBConnectionDataFile" ]]; then
  echo "create new config file"
  touch $DBConnectionDataFile
  echo "{\"type\": \"pgsql\", \"host\": \"${POSTGRES_HOST}\", \"port\": \"${POSTGRES_PORT}\", \"dbname\": \"${POSTGRES_DB}\", \"user\": \"${POSTGRES_USER}\", \"password\": \"${POSTGRES_PASSWORD}\"}" > $DBConnectionDataFile
fi


## init data
#php /var/www/html/scripts/initialize.php \
#  --user_name=$SUPERUSER_NAME \
#  --user_password=$SUPERUSER_PASSWORD \
#  --workspace=$WORKSPACE_NAME \
#  --test_login_name=$TEST_LOGIN_NAME \
#  --test_login_password=$TEST_LOGIN_PASSWORD \
#  --test_person_codes="xxx yyy"

# data-dir
DataDir=/var/www/html/vo_data
if [[ ! -d "$DataDir" ]]; then
  echo "create data-dir"
  mkdir $DataDir
fi
# file-rights
chown -R www-data:www-data $DataDir

# keep container open
apache2-foreground
