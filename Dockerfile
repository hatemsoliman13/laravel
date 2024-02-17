FROM php:8.3.0-apache-bullseye

RUN apt update
RUN apt install -y git \
    zip \
    unzip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer
RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY ./apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN echo "\n\
zend_extension=xdebug.so \n\
xdebug.mode=develop,coverage,debug,profile \n\
xdebug.idekey=docker \n\
xdebug.start_with_request=yes \n\
xdebug.log=/dev/stdout \n\
xdebug.log_level=0 \n\
xdebug.client_port=9003 \n\
xdebug.client_host=192.168.1.13 \n\
" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  
