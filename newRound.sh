#!/bin/bash
clear;


# shellcheck disable=SC2046
docker stop `docker ps -qa` && docker rm `docker ps -qa`
docker image prune -af
docker container prune -af
docker volume prune -f
docker network prune -f
docker system prune -f



docker build -t teststudio-lite-db-postgres teststudio-lite-db-postgres
docker run --name=teststudio-lite-db-postgres teststudio-lite-db-postgres

