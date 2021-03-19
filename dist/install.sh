#!/bin/bash

set -e

# Author: Richard Henck (richard.henck@iqb.hu-berlin.de)

### Check installed tools ###
CHECK_INSTALLED=`docker -v`;
if [[ $CHECK_INSTALLED = "docker: command not found" ]]; then
  echo "Docker not found, please install before running!"
  exit 1
else
  echo "Docker found"
fi

CHECK_INSTALLED=`docker-compose -v`;
if [[ $CHECK_INSTALLED = "docker-compose: command not found" ]]; then
  echo "Docker-compose not found, please install before running!"
  exit 1
else
  echo "Docker-Compose found"
fi

CHECK_INSTALLED=`make -v`;
if [[ $CHECK_INSTALLED = "make: command not found" ]]; then
  echo "Make not found! It is recommended to control the application."
  read  -p 'Continue anyway? (y/N): ' -e CONTINUE

  if [[ $CONTINUE != "y" ]]; then
    exit 1
  fi
else
  echo "Make found"
fi

### Unpack application ###
read  -p 'Install directory: ' -e -i "`pwd`/teststudio-lite" TARGET_DIR

mkdir $TARGET_DIR
tar -xf *.tar -C $TARGET_DIR

# ### Set up config ###
read  -p 'Server Address (hostname or IP): ' -e -i $(hostname) HOSTNAME
sed -i "s/localhost/$HOSTNAME/" .env

echo '
Database Settings'
echo ' You can press Enter on the password prompts and default values are used.
 This strongly disadvised. Always use proper passwords!'
POSTGRES_DB=teststudio_lite_db
POSTGRES_USER=teststudio_lite_db_user
POSTGRES_PASSWORD=iqb_tba_db_password_1
read  -p 'Database name: ' -e -i $POSTGRES_DB POSTGRES_DB
sed -i "s/teststudio_lite_db/$MYSQL_DATABASE/" .env
read  -p 'Database user: ' -e -i $POSTGRES_USER POSTGRES_USER
sed -i "s/teststudio_lite_db_user/$POSTGRES_USER/" .env
read  -p 'Database user password: ' -e -i $POSTGRES_PASSWORD POSTGRES_PASSWORD
sed -i "s/iqb_tba_db_password_1/$POSTGRES_PASSWORD/" .env

# read  -p 'Use TLS? (y/N): ' -e TLS
# if [ $TLS = 'y' ]
# then
#   echo "The certificates need to be placed in config/certs and their name configured in config/cert_config.yml."
#   sed -i 's/http:/https:/' .env
#   sed -i 's/ws:/wss:/' .env
# fi

### Populate Makefile ###
# if [ $TLS = 'y' ]
# then
#   rm docker-compose.prod.nontls.yml
#   sed -i 's/<run-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.tls.yml up/' Makefile-template
#   sed -i 's/<run-datached-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.tls.yml up -d/' Makefile-template
#   sed -i 's/<stop-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.tls.yml stop/' Makefile-template
#   sed -i 's/<down-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.tls.yml down/' Makefile-template
#   sed -i 's/<pull-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.tls.yml pull/' Makefile-template
# else
  # rm docker-compose.prod.tls.yml
  sed -i 's/<run-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.yml up/' Makefile-template
  sed -i 's/<run-datached-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d/' Makefile-template
  sed -i 's/<stop-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.yml stop/' Makefile-template
  sed -i 's/<down-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.yml down/' Makefile-template
  sed -i 's/<pull-command>/docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull/' Makefile-template
# fi

mv Makefile-template Makefile

echo '
 --- INSTALLATION SUCCESSFUL ---
'
echo 'Check the settings and passwords in the file '.env' in the installation directory.'