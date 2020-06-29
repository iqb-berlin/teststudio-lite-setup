FROM postgres:9.6

LABEL maintainer="IQB Berlin"
LABEL version="1.0"
LABEL description="PostgreSQL Container for teststudio-lite backend db"
LABEL license="MIT"

ARG POSTGRES_DB=teststudio_lite_db
ARG POSTGRES_USER=teststudio_lite_db_user
ARG POSTGRES_PASSWORD=iqb_tba_db_password_1

ENV POSTGRES_DB="${POSTGRES_DB}"
ENV POSTGRES_USER="${POSTGRES_USER}"
ENV POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"

# config
COPY config/pg_hba.conf /opt/pg_hba.conf
RUN echo "host $POSTGRES_DB $POSTGRES_USER all md5" >> /opt/pg_hba.conf
RUN chmod 777 /opt/pg_hba.conf

# import database
COPY initdb/init.sql /docker-entrypoint-initdb.d/1-db.postgres.sql
CMD ["postgres", "-c", "hba_file=/opt/pg_hba.conf"]
