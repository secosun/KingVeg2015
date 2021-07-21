#制作Drupal镜像
FROM mysqlphpbase as builderPHP
#生成PHP镜像
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

COPY --from=builderPHP /usr/share/nginx/html /usr/share/nginx/html
#COPY auth.json ~/.composer/auth.json
WORKDIR /opt/drupal-7.80
CMD php-fpm -c /usr/local/php73/etc/php.ini -y /usr/local/php73/etc/php-fpm.d/www.conf \
    && tail -F /var/log/www.slow.log
