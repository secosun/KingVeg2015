FROM alpine:3.12.0 AS builderPHP
WORKDIR /opt
COPY php736.tar.gz . 
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update \
    && apk add --no-cache build-base
RUN apk add --no-cache libxml2 libxml2-dev
RUN apk add --no-cache openssl openssl-dev
RUN apk add --no-cache curl curl-dev
RUN apk add --no-cache gdbm-dev
RUN apk add --no-cache libjpeg-turbo-dev libjpeg-turbo
RUN apk add --no-cache libpng libpng-dev
RUN apk add --no-cache gettext gettext-dev
RUN apk add --no-cache icu-dev
RUN apk add --no-cache libzip libzip-dev
RUN apk add --no-cache ldb-dev libldap openldap-dev
RUN apk add --no-cache make

RUN tar zxvf php736.tar.gz \
    && chmod 777 -R php-7.3.6/ \
    && cd php-7.3.6 \
    && mkdir -p  /usr/local/php73 && mkdir -p  /usr/local/php73/etc \
#    && ./configure --enable-shared=no --enable-static=yes \
    && ./configure \
    --prefix=/usr/local/php73 \
    --with-config-file-path=/usr/local/php73/etc \ 
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \ 
    --with-iconv-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib \
    --with-libxml-dir \ 
    --with-ldap=shared \
    --with-gdbm \
    --with-pear \
    --with-gettext \ 
    --with-curl \
    --with-xmlrpc \
    --with-openssl \
    --with-mhash \
    --with-gd \
    --enable-fpm \ 
    --enable-mysqlnd \  
    --enable-mysqlnd-compression-support \ 
    --enable-xml \
    --enable-rpath \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \ 
    --enable-mbregex \
    --enable-mbstring \
    --enable-intl \
    --enable-ftp \
    --enable-gd-jis-conv \ 
    --enable-pcntl \
    --enable-sockets \ 
    --enable-zip \
    --enable-soap \
    --enable-fileinfo \ 
    --enable-opcache \
    --enable-maintainer-zts \ 
    && make -j4 && make install

RUN cp /opt/php-7.3.6/php.ini-development /usr/local/php73/etc/php.ini 

RUN cp /usr/local/php73/etc/php-fpm.conf.default /usr/local/php73/etc/php-fpm.conf \
    && cp /usr/local/php73/etc/php-fpm.d/www.conf.default /usr/local/php73/etc/php-fpm.d/www.conf \
    && echo "max_execution_time = 120" >> /usr/local/php73/etc/php.ini \
    && echo "max_input_time = 120" >> /usr/local/php73/etc/php.ini \
    && echo "memory_limit = 1024M" >> /usr/local/php73/etc/php.ini \
    && echo "post_max_size = 128M" >> /usr/local/php73/etc/php.ini \
    && echo "date.timezone = PRC" >> /usr/local/php73/etc/php.ini \
    && echo "extension_dir = '/usr/local/php73/lib/php/extensions/no-debug-zts-20180731'" >> /usr/local/php73/etc/php.ini \
    && ln -s /usr/local/php73/bin/php /usr/bin/php \
    && ln -s /usr/local/php73/sbin/php-fpm /usr/sbin/php-fpm \
    && echo "listen = 0.0.0.0:9000" >> /usr/local/php73/etc/php-fpm.d/www.conf \
    && /usr/local/php73/sbin/php-fpm -t \
    && php -v
#RUN apk add --no-cache git
COPY auth.json /root/.composer/auth.json
#COPY id_rsa  id_rsa.pub   /root/.ssh/
RUN mkdir -p /usr/share/nginx/html \
     && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
     && php composer-setup.php \
     && mv composer.phar /usr/local/bin/composer \
     && composer -V \
     && ls -l \
     && composer create-project secosun/drupal-project:dev-jhvege /opt/drupal-7.80 --prefer-dist --remove-vcs --repository "{\"type\": \"vcs\", \"url\": \"https://github.com/secosun/drupal-project\"}"
RUN apk add --no-cache mysql-client

FROM alpine:3.12.0
RUN adduser -D -g www www 

COPY --from=builderPHP /opt/drupal-7.80 /opt/drupal-7.80/
COPY --from=builderPHP /usr/local/php73/etc/ /usr/local/php73/etc/
COPY --from=builderPHP /usr/local/php73/var/ /usr/local/php73/var/
COPY --from=builderPHP /usr/lib/libzip.so.5 /lib/libz.so.1 /usr/lib/libstdc++.so.6 /usr/lib/libintl.so.8 /usr/lib/libgdbm.so.4  /usr/lib/libpng16.so.16 \
      /usr/lib/libjpeg.so.8 /usr/lib/libxml2.so.2 /lib/libssl.so.1.1 /lib/libcrypto.so.1.1 /usr/lib/libcurl.so.4 /usr/lib/libicuio.so.67 /usr/lib/libicui18n.so.67 /usr/lib/libicuuc.so.67 \
      /usr/lib/libgcc_s.so.1  /usr/lib/liblzma.so.5 /usr/lib/libnghttp2.so.14 /usr/lib/libicudata.so.67 \
      /lib/libssl.so.1.1  /lib/libcrypto.so.1.1  /lib/libz.so.1  /usr/lib/libncursesw.so.6  /usr/lib/libstdc++.so.6  /usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=builderPHP /usr/sbin/php-fpm /usr/sbin/
COPY --from=builderPHP /usr/bin/mysql /usr/bin/php /usr/bin/ 
#COPY auth.json ~/.composer/auth.json
WORKDIR /opt/drupal-7.80
CMD php-fpm -c /usr/local/php73/etc/php.ini -y /usr/local/php73/etc/php-fpm.d/www.conf \
    && sleep 60 \
    && ./vendor/bin/drush --version \
    && ./vendor/bin/drush si --db-url=mysql://root:123456@db:3306/drupal7 -y -vvv \
    && ./vendor/bin/drush user-password admin --password=12345!@#$% \
    && cp -rf . /usr/share/nginx/html \
    && tail -F /var/log/www.slow.log
