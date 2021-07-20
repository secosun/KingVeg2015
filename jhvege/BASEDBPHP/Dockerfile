#包含PHP与mysql的基础镜像
FROM alpine:3.12.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV rootpasswd 123456 
RUN apk add  'mariadb=10.4.19-r0' 'mariadb-client=10.4.19-r0'
COPY mysqlinit.txt /
COPY jingheproduct.sql /
COPY mysql.sh /
COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY my.cnf /etc/my.cnf
RUN mysql_install_db  --user=mysql --ldata=/var/lib/mysql

RUN mysqld_safe --datadir='/var/lib/mysql' & sleep 3 \
   && echo -e "\nn\nY\n$rootpasswd\n$rootpasswd\nY\nn\nY\nY\n"  | mysql_secure_installation \
   && mysql -uroot -p$rootpasswd < mysqlinit.txt \
   && chmod +x mysql.sh \
   && ./mysql.sh \
   && killall -9 mysqld_safe
#以上是数据库部分
#--------------------------------------------------------------------------------------------------------------
#下面是源码安装的PHP
WORKDIR /opt
COPY php736.tar.gz . 
RUN apk update \
    && apk add  build-base
RUN apk add  libxml2 libxml2-dev
RUN apk add  openssl openssl-dev
RUN apk add  curl curl-dev
RUN apk add  gdbm-dev
RUN apk add  libjpeg-turbo-dev libjpeg-turbo
RUN apk add  libpng libpng-dev
RUN apk add  gettext gettext-dev
RUN apk add  icu-dev
RUN apk add  libzip libzip-dev
RUN apk add  ldb-dev libldap openldap-dev
RUN apk add  make

RUN tar zxvf php736.tar.gz \
    && chmod 777 -R php-7.3.6/ \
    && cd php-7.3.6 \
    && mkdir -p  /usr/local/php73 && mkdir -p  /usr/local/php73/etc \
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
#RUN apk add  git
COPY auth.json /root/.composer/auth.json
#COPY id_rsa  id_rsa.pub   /root/.ssh/
#下面开始部署项目--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RUN mkdir -p /usr/share/nginx/html \
     && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
     && php composer-setup.php \
     && mv composer.phar /usr/local/bin/composer \
     && composer -V \
     && ls -l \
     && composer create-project secosun/drupal-project:dev-jhvege /opt/drupal-7.80 --prefer-dist --remove-vcs --repository "{\"type\": \"vcs\", \"url\": \"https://github.com/secosun/drupal-project\"}"
#RUN apk add  mysql-client
#下面开始安装项目--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WORKDIR /opt/drupal-7.80
RUN adduser -D -g www www 
RUN mysqld_safe --datadir='/var/lib/mysql' --user=root & sleep 10 \
    && ps -ef && cat /var/lib/mysql/*.err \
    && php-fpm -c /usr/local/php73/etc/php.ini -y /usr/local/php73/etc/php-fpm.d/www.conf \
    && ./vendor/bin/drush --version \
    && ./vendor/bin/drush si --db-url=mysql://root:123456@127.0.0.1:3306/drupal7 -y -vvv \
    && ./vendor/bin/drush user-password admin --password=12345!@#$%
RUN cp -rf . /usr/share/nginx/html \
    && sed -i 's/127.0.0.1/db/g' /usr/share/nginx/html/web/sites/default/settings.php




