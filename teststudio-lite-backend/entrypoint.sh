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


#deploy plugins
playersDir=/var/www/html/itemplayers
chown -R www-data:www-data "$playersDir"
if [[ ! "$(ls $playersDir)" ]]; then
  echo "importing dan-player/player 2.1.0"
  cp /teststudio-lite-plugins/verona-player-dan/releases/2.1.0/unitPlayer/IQBVisualUnitPlayerV2.1.0.html \
    "$playersDir/IQBVisualUnitPlayerV2.html" # must be renamed, because teststudio-lite does not support sub-versions
fi

editorsDir=/var/www/html/itemauthoringtools
chown -R www-data:www-data "$editorsDir"
if [[ ! "$(ls $editorsDir)" ]]; then
  echo "importing dan-player/editor 2.1.0"
  mkdir /var/www/html/itemauthoringtools/dan-player-2.1.0
  cp -R /teststudio-lite-plugins/verona-player-dan/releases/2.1.0/unitAuthoring/* \
    "$editorsDir/dan-player-2.1.0/"
  echo "<?xml version=\"1.0\"?>" \
    >> "$editorsDir/metadata.xml";
  echo "<itemauthoringtools><tool id=\"dan-player-2.1.0\">dan-player-2.1.0</tool></itemauthoringtools>" \
    >> "$editorsDir/metadata.xml";
fi

# add super user and workspace
cd /var/www/html/create || exit
php init.cli.php --user_name=$SUPERUSER_NAME --user_password=$SUPERUSER_PASSWORD --workspace_name=$WORKSPACE_NAME


# keep container open
apache2-foreground
