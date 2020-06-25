FROM postgres:9.6

LABEL maintainer="IQB Berlin"
LABEL version="1.0"
LABEL description="PostgreSQL Container for teststudio-lite backend db"
LABEL license="MIT"

ENV POSTGRES_DB=teststudio_lite_db
ENV POSTGRES_USER=teststudio_lite_db_user
ENV POSTGRES_PASSWORD=iqb_tba_db_password_1

# config
#RUN echo "host all all all trust" >> /var/lib/postgresql/data/pg_hba.conf
#RUN echo "host $POSTGRES_DB  $POSTGRES_USER    teststudio-lite-backend  md5" >> /var/lib/postgresql/data/pg_hba.conf
#RUN echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf
COPY config/pg_hba.conf /opt/pg_hba.conf

#COPY config/my.cnf /etc/mysql/conf.d/my.cnf

# import database and createsuperuser script
COPY initdb/init.sql /docker-entrypoint-initdb.d/1-db.postgres.sql
CMD ["postgres", "-c", "hba_file=/opt/pg_hba.conf"]
