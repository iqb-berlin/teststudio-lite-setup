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


# data-dir
DataDir=/var/www/html/vo_data
if [[ ! -d "$DataDir" ]]; then
  echo "create data-dir"
  mkdir $DataDir
fi
# file-rights
chown -R www-data:www-data $DataDir


# add super user
cd /var/www/html/create || exit
php init.cli.php --user_name=$SUPERUSER_NAME --user_password=$SUPERUSER_PASSWORD


# keep container open
apache2-foreground
