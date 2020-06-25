#!/bin/bash
echo "host $POSTGRES_DB $POSTGRES_USER all md5" >> /opt/pg_hba.conf
more /opt/pg_hba.conf;
