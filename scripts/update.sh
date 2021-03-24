#!/bin/bash

OLD_BACKEND_VERSION=`grep 'image: iqbberlin/teststudio-lite-backend:' docker-compose.prod.yml \
| cut -d : -f 3`
OLD_FRONTEND_VERSION=`grep 'image: iqbberlin/teststudio-lite-frontend:' docker-compose.prod.yml \
| cut -d : -f 3`

TAG=`curl -s https://api.github.com/repos/iqb-berlin/teststudio-lite-setup/releases/latest \
| grep "tag_name" \
| cut -d : -f 2 \
| tr -d \" \
| tr -d , \
| tr -d ' '`

NEW_FRONTEND_VERSION=$(echo $TAG | cut -d '@' -f 1)
NEW_BACKEND_VERSION=$(echo $TAG | cut -d '@' -f 2)

compare_version_string() {
  test $(echo $1 | cut -d '.' -f 1) -eq $(echo $2 | cut -d '.' -f 1)
  first_number_equals=$?
  test $(echo $1 | cut -d '.' -f 2) -eq $(echo $2 | cut -d '.' -f 2)
  second_number_equals=$?

  if [ $(echo $1 | cut -d '.' -f 1) -gt $(echo $2 | cut -d '.' -f 1) ]
    then
      NEWER_VERSION=true
  fi
  if [ $first_number_equals = 0 ] && [ $(echo $1 | cut -d '.' -f 2) -gt $(echo $2 | cut -d '.' -f 2) ]
    then
      NEWER_VERSION=true
  fi
  if [ $first_number_equals = 0 ] && [ $second_number_equals = 0 ] && [ $(echo $1 | cut -d '.' -f 3) -gt $(echo $2 | cut -d '.' -f 3) ]
    then
      NEWER_VERSION=true
  fi

}

NEWER_VERSION=false
compare_version_string $NEW_BACKEND_VERSION $OLD_BACKEND_VERSION
compare_version_string $NEW_FRONTEND_VERSION $OLD_FRONTEND_VERSION
if [ $NEWER_VERSION = 'true' ]
  then
    echo "Newer version found:
Backend: $OLD_BACKEND_VERSION -> $NEW_BACKEND_VERSION
Frontend: $OLD_FRONTEND_VERSION -> $NEW_FRONTEND_VERSION"
  else
    echo 'You are up to date'
    exit 0
fi

read -p "Do you want to update to the latest release? [Y/n]:" -e UPDATE
if [[ $DOWNLOAD != "n" ]]
  then
    sed -i "s/image: iqbberlin\/teststudio-lite-backend:.*/image: iqbberlin\/teststudio-lite-backend:$NEW_BACKEND_VERSION/" docker-compose.prod.yml
    sed -i "s/image: iqbberlin\/teststudio-lite-frontend:.*/image: iqbberlin\/teststudio-lite-frontend:$NEW_FRONTEND_VERSION/" docker-compose.prod.yml
fi

read -p "Update applied. Do you want to restart the server? This may take a few minutes. [Y/n]:" -e RESTART
if [[ $RESTART != "n" ]]
  then
    make down
    make pull
    make run-detached
fi
