FROM centos:7
WORKDIR /opt
COPY php736.tar.gz . 
COPY libzip120.tar.gz .
COPY re2c-0.13.7.5.tar.gz .
RUN tar zxvf php736.tar.gz \
    && yum -y update \
    && yum -y install gcc gcc-c++ kernel-devel \
    && yum -y install wget pcre pcre-devel openssl openssl-devel libicu-devel autoconf \
    libjpeg libjpeg-devel libpng libpng-devel libxml2 libxml2-devel \
    zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses ncurses-devel curl curl-devel \
    krb5-devel libidn libidn-devel openldap openldap-devel nss_ldap jemalloc-devel \
    cmake boost-devel bison automake libevent libevent-devel gd gd-devel libtool* libmcrypt \
    libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline readline-devel \
    gmp gmp-devel libcurl libcurl-devel openjpeg-devel gdbm-devel \
    && groupadd www \
    && useradd -g www www  \
    && yum install -y openldap openldap-servers openldap-clients \
    && cp -frp /usr/lib64/libldap* /usr/lib/ \
    && yum provides '*/applydeltarpm' \  
    && yum install deltarpm -y \
    && tar zxvf libzip120.tar.gz \
    && cd libzip-1.2.0 \
    && ./configure \
    && make -j4 \
    && make install \
    && cd .. \
    && tar zxvf re2c-0.13.7.5.tar.gz \
    && cd re2c-0.13.7.5 && ./configure && make && make install \
    && cd .. \
    && cd php-7.3.6 \
    && mkdir -p  /usr/local/webservice/php73 && mkdir -p  /usr/local/webservice/php73/etc \
    && cp /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h \
    && ./configure --prefix=/usr/local/webservice/php73 \
    --with-config-file-path=/usr/local/webservice/php73/etc \ 
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
    && make -j 4 && make install

RUN pwd && ls -l /usr/local/webservice/php73/etc/ 
RUN cp /opt/php-7.3.6/php.ini-development /usr/local/webservice/php73/etc/php.ini \
    && ls /usr/local/webservice/php73/etc/php-fpm.d \
    && cp /usr/local/webservice/php73/etc/php-fpm.conf.default /usr/local/webservice/php73/etc/php-fpm.conf \
    && cp /usr/local/webservice/php73/etc/php-fpm.d/www.conf.default /usr/local/webservice/php73/etc/php-fpm.d/www.conf \
    && echo "max_execution_time = 120" >> /usr/local/webservice/php73/etc/php.ini \
    && echo "max_input_time = 120" >> /usr/local/webservice/php73/etc/php.ini \
    && echo "memory_limit = 1024M" >> /usr/local/webservice/php73/etc/php.ini \
    && echo "post_max_size = 128M" >> /usr/local/webservice/php73/etc/php.ini \
    && echo "date.timezone = PRC" >> /usr/local/webservice/php73/etc/php.ini \
    && echo "extension_dir = '/usr/local/webservice/php73/lib/php/extensions/no-debug-zts-20180731'" >> /usr/local/webservice/php73/etc/php.ini \
    && cp /opt/php-7.3.6/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm \
    && ln -s /usr/local/webservice/php73/bin/php /usr/bin/php \
    && ln -s /usr/local/webservice/php73/sbin/php-fpm /usr/sbin/php-fpm \
    && echo "listen = 0.0.0.0:9000" >> /usr/local/webservice/php73/etc/php-fpm.d/www.conf \
    && /usr/local/webservice/php73/sbin/php-fpm -t \
    && php -v

COPY id_rsa  id_rsa.pub   /root/.ssh/
RUN mkdir -p /usr/share/nginx/html \
     && curl -sS https://getcomposer.org/installer | php \
     && mv composer.phar /usr/local/bin/composer \
     && yum install -y git \
     && git config --global user.name "secosun" \
     && git config --global user.email "1059095187@qq.com" \
     && yum install zip unzip -y \
     && composer create-project secosun/drupal-project:2.0.0 /opt/drupal-7.80  --repository "{\"type\": \"vcs\", \"url\": \"https://github.com/secosun/drupal-project\"}" \
     && yum install -y which
WORKDIR /opt/drupal-7.80
RUN yum install -y mysql
CMD php -v \
    && php-fpm -c /usr/local/webservice/php73/etc/php.ini -y /usr/local/webservice/php73/etc/php-fpm.d/www.conf \
    && sleep 60 \
    && vendor/bin/drush --version \
    && vendor/bin/drush si --db-url=mysql://root:123456@db:3306/drupal7 -y -vvv \
    && vendor/bin/drush user-password admin --password=12345!@#$% \
    && cp -rf web/. /usr/share/nginx/html \
    && tail -f --retry /var/log/www.slow.log
