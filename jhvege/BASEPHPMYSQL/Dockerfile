#制作Drupal镜像
FROM ghcr.io/secosun/jhvegebase as builderPHP
#下面开始部署项目--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RUN mkdir -p /usr/share/nginx/html \
     && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
     && php composer-setup.php \
     && mv composer.phar /usr/local/bin/composer \
     && composer config --global --auth github-oauth.github.com  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 \
     && composer create-project secosun/drupal-project:dev-jhvege /opt/drupal-7.80 --prefer-dist --remove-vcs --repository "{\"type\": \"vcs\", \"url\": \"https://github.com/secosun/drupal-project\"}"
#RUN apk add  mysql-client
#下面开始安装项目--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WORKDIR /opt/drupal-7.80/web
RUN adduser -D -g www www 
RUN mysqld_safe --datadir='/var/lib/mysql' --user=root & sleep 30 \
    && ps -ef && cat /var/lib/mysql/*.err \
    && php-fpm -c /usr/local/php73/etc/php.ini -y /usr/local/php73/etc/php-fpm.d/www.conf \
    && ls \
    && ../vendor/bin/drush si --db-url=mysql://root:123456@127.0.0.1:3306/drupal7 -y -vvv \
    && ../vendor/bin/drush user-password admin --password=12345!@#$%
WORKDIR /opt/drupal-7.80
RUN cp -rf . /usr/share/nginx/html \
    && ls /usr/share/nginx/html \
    && sed -i 's/127.0.0.1/db/g' /usr/share/nginx/html/web/sites/default/settings.php

