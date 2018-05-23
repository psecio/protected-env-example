FROM php:7.2-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git vim sudo

# Copy over all the files we need
COPY . /var/www/html
COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./open_basedir.ini /usr/local/etc/php/conf.d/open_basedir.ini

# Move the settings to the right place & configure for Apache to use
RUN mv /var/www/html/test-settings /tmp/test-settings
RUN cat ./envvars >> /etc/apache2/envvars

# Enable modules and restart Apache
RUN a2enmod vhost_alias
RUN /usr/sbin/apachectl restart