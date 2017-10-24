FROM debian:9.1
RUN apt-get update
RUN apt-get -y install apache2
RUN apt-get -y install php
RUN apt-get -y install php-all-dev
RUN apt-get -y install php-mbstring
RUN apt-get -y install php-gd
RUN apt-get -y install composer
RUN apt-get -y install php-mysql
RUN apt-get -y install sudo
RUN apt-get -y install mysql-client
RUN apt-get -y install vim
RUN rm /var/www/html/index.html
RUN a2enmod rewrite
COPY apache2.conf /etc/apache2/apache2.conf
COPY apache-site.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /etc/php/7.0/apache2/php.ini
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
RUN service apache2 restart
WORKDIR /var/www/
COPY html.tar.gz .
RUN chown www-data.www-data /var/www/
RUN chown www-data.www-data /var/www/html
RUN sudo -u www-data tar --warning=no-unknown-keyword -zxvf html.tar.gz
WORKDIR /var/www/html/
COPY settings.php /var/www/html/sites/default/settings.php
RUN sudo -u www-data composer install
RUN sudo -u www-data composer require drupal/flysystem
RUN sudo -u www-data composer require drupal/flysystem_s3
RUN sudo -u www-data composer require drush/drush
WORKDIR /var/www/html/sites/default
COPY create.sql create.sql
COPY start.sh /usr/www/start.sh
RUN chown -R www-data.www-data /var/www/html/sites/default/
RUN apachectl stop
CMD /usr/www/start.sh
