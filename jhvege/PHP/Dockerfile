#制作Drupal镜像
FROM ghcr.io/secosun/mysqlphpbase as builderPHP
#生成PHP镜像
FROM alpine:3.12.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
&& echo 'https://mirror.tuna.tsinghua.edu.cn/alpine/v3.9/main' >> /etc/apk/repositories \
&& echo 'https://mirror.tuna.tsinghua.edu.cn/alpine/v3.9/community' >> /etc/apk/repositories


RUN apk add --no-cache shadow
RUN adduser -D -g www www 
# 指定创建的非root用户
ARG USERNAME=vscode
ARG USER_UID=1007
ARG USER_GID=$USER_UID
 # 创建一个非root用户 (为啥需要这个，请看 - https://aka.ms/vscode-remote/containers/non-root-user)
#RUN addgroup -g $USER_GID $USERNAME\
RUN adduser -D -u $USER_UID -g $USERNAME $USERNAME 
#USER $USERNAME

COPY --from=builderPHP /opt/drupal-7.80 /opt/drupal-7.80/
COPY --from=builderPHP /usr/local/php73/etc/ /usr/local/php73/etc/
COPY --from=builderPHP /usr/local/php73/var/ /usr/local/php73/var/
COPY --from=builderPHP /usr/lib/libzip.so.5 /lib/libz.so.1 /usr/lib/libstdc++.so.6 /usr/lib/libintl.so.8 /usr/lib/libgdbm.so.4  /usr/lib/libpng16.so.16 \
      /usr/lib/libjpeg.so.8 /usr/lib/libxml2.so.2 /lib/libssl.so.1.1 /lib/libcrypto.so.1.1 /usr/lib/libcurl.so.4 /usr/lib/libicuio.so.67 /usr/lib/libicui18n.so.67 /usr/lib/libicuuc.so.67 \
      /usr/lib/libgcc_s.so.1  /usr/lib/liblzma.so.5 /usr/lib/libnghttp2.so.14 /usr/lib/libicudata.so.67 \
      /lib/libssl.so.1.1  /lib/libcrypto.so.1.1  /lib/libz.so.1  /usr/lib/libncursesw.so.6  /usr/lib/libstdc++.so.6  /usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=builderPHP /usr/sbin/php-fpm /usr/sbin/
COPY --from=builderPHP /usr/bin/mysql /usr/bin/php /usr/bin/ 
COPY --from=builderPHP /usr/local/php73/lib/php/extensions/no-debug-zts-20180731 /usr/local/php73/lib/php/extensions/no-debug-zts-20180731/

COPY --from=builderPHP /usr/share/nginx/html /usr/share/nginx/html
#COPY auth.json ~/.composer/auth.json
WORKDIR /opt/drupal-7.80
CMD php-fpm -c /usr/local/php73/etc/php.ini -y /usr/local/php73/etc/php-fpm.d/www.conf \
    && tail -F /var/log/www.slow.log

#vscode 调试集成到docker-comose 远程开发方案
COPY .vscode/launch.json /usr/share/nginx/html/web/.vscode/launch.json
COPY id_rsa id_rsa.pub known_hosts /root/.ssh/
RUN apk add git &&  apk add openssh && chmod 600 /root/.ssh/id_rsa
#RUN cd /usr/share/nginx/html/web && git remote add origin git@github.com:secosun/drupaldev.git
RUN cd /usr/share/nginx/html/web && git clone git@github.com:secosun/drupaldev.git