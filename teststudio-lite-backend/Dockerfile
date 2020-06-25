FROM php:7.3-apache-buster

LABEL maintainer="IQB Berlin"
LABEL version="1.0"
LABEL description="The PHP backend of the teststudio-lite. This container ist for DEVELOPMENT only, not for deployment!"
LABEL license="MIT"

# environment vars
#ENV SUPERUSER_NAME=super
#ENV SUPERUSER_PASSWORD=user456
#ENV TEST_LOGIN_NAME=testlogin
#ENV TEST_LOGIN_PASSWORD=user789
#ENV WORKSPACE_NAME=brand_new_workspace
ENV POSTGRES_DB=teststudio_lite_db
ENV POSTGRES_USER=teststudio_lite_db_user
ENV POSTGRES_PASSWORD=iqb_tba_db_password_1
ENV POSTGRES_HOST=teststudio-lite-db-postgres
ENV POSTGRES_PORT=9097

## dependencies
RUN apt-get update && \
    apt-get install -y libpq-dev zlib1g-dev libzip-dev unzip

# install php extensions
RUN docker-php-ext-install -j$(nproc) pdo_pgsql zip

# set up apache
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2dissite 000-default
COPY config/vhost.conf /etc/apache2/sites-available
RUN a2ensite vhost
RUN echo "ServerName localhost" >> /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# set up php
COPY config/local.php.ini /usr/local/etc/php/conf.d/local.ini

# copy source code
COPY src/ /var/www/html

# set file rights
RUN chown -R www-data:www-data /var/www/html

# install composer dependencies
#RUN sh scripts/install_composer.sh
#RUN php composer.phar install


EXPOSE 80

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod 777 /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
