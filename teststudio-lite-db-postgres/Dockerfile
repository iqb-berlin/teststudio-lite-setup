FROM postgres:9.6

LABEL maintainer="IQB Berlin"
LABEL version="1.0"
LABEL description="PostgreSQL Container for teststudio-lite backend db"
LABEL license="MIT"

ENV POSTGRES_DB=teststudio_lite_db
ENV POSTGRES_USER=teststudio_lite_db_user
ENV POSTGRES_PASSWORD=iqb_tba_db_password_1

RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8

# config
#COPY config/my.cnf /etc/mysql/conf.d/my.cnf

# import database and createsuperuser script
COPY initdb/init.sql /docker-entrypoint-initdb.d/1-db.postgres.sql
