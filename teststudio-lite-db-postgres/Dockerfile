FROM postgres:9.6

LABEL maintainer="IQB Berlin"
LABEL version="1.0"
LABEL description="PostgreSQL Container for teststudio-lite backend db"
LABEL license="MIT"

ENV POSTGRES_DB=teststudio_lite_db
ENV POSTGRES_USER=teststudio_lite_db_user
ENV POSTGRES_PASSWORD=iqb_tba_db_password_1

# config
COPY config/pg_hba.conf /opt/pg_hba.conf
RUN chmod 777 /opt/pg_hba.conf

# import database and createsuperuser script
COPY initdb/init.sql /docker-entrypoint-initdb.d/1-db.postgres.sql
COPY initdb/write_pg_hba.conf.sh /docker-entrypoint-initdb.d/2-write_pg_hba.conf.sh
CMD ["postgres", "-c", "hba_file=/opt/pg_hba.conf"]
