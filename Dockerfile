# PHPCI - PHP Continuous Integration
#
# VERSION 1.0

FROM ubuntu:12.04
MAINTAINER Dan Cryer dan.cryer@block8.co.uk

# Set up the repositories we want to use:
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu precise main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu precise main" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C E5267A6C 0xcbcb082a1bb943db
RUN apt-get update

# Install PHP-FPM and nginx:
RUN apt-get install -qy php5-common php5-fpm php5-cli php5-curl php5-imap php5-mcrypt php5-mysqlnd nginx curl

# Remove default / old config files:
RUN rm -f /etc/nginx/sites-enabled/*
RUN rm -f /etc/php5/fpm/pool.d/*.conf

# Add our PHP-FPM config file:
ADD conf/docker/nginx.conf /etc/nginx/sites-enabled/phpci
ADD conf/docker/phpfpm.conf /etc/php5/fpm/pool.d/phpci.conf

# Copy in PHPCI files, run Composer, etc:
ADD ./ /www/phpci
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin
RUN composer.phar install --prefer-dist --no-progress --no-interaction --working-dir=/www/phpci

EXPOSE 5000

CMD /usr/sbin/php5-fpm -D && /usr/sbin/nginx && /bin/bash