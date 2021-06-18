FROM centos:7
RUN yum install -y epel-release \
    && yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum install -y yum-utils \
    && yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json \
       php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto \
       php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml  php73-php-zip \
    && sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/opt/remi/php73/php.ini
RUN  ln -s  /opt/remi/php73/root/usr/bin/php  /usr/bin/ && /opt/remi/php73/root/usr/sbin/php-fpm -t 
#关闭php-fpm
#kill -INT `cat /usr/local/php/var/run/php-fpm.pid`
#重启php-fpm
#kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
COPY id_rsa  id_rsa.pub   /root/.ssh/
RUN mkdir -p /usr/share/nginx/html \
#    && touch /usr/share/nginx/html/info.php
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
CMD /opt/remi/php73/root/usr/bin/php -v \
    && /opt/remi/php73/root/usr/sbin/php-fpm -c /etc/opt/remi/php73/php.ini -y /etc/opt/remi/php73/php-fpm.conf \
    && sleep 60 \
    && vendor/bin/drush si --db-url=mysql://root:123456@127.0.0.1:3306/drupal7 -y -vvv \
    && vendor/bin/drush user-password admin --password=12345!@#$% \
    && cp -rf web/ /usr/share/nginx/html \
    && tail -f --retry /var/log/www.slow.log
