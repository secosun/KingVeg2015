#制作mysql数据库镜像
FROM ghcr.io/secosun/mysqlphpbase:v1 as builderDB
FROM alpine:3.12.0
COPY --from=builderDB /usr/bin/my* /usr/bin/ 
COPY --from=builderDB /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY --from=builderDB /etc/my.cnf  /etc/my.cnf
COPY --from=builderDB /var/lib/mysql /var/lib/mysql
COPY --from=builderDB /usr/lib/libstdc++.so.6 /usr/lib/libncursesw.so.6 /usr/lib/libgcc_s.so.1 /usr/lib/liblzma.so.5 /usr/lib/libaio.so.1 \ 
     /usr/lib/libaio.so.1 /usr/lib/libpcre.so.1 /usr/lib/
CMD mysqld_safe --datadir='/var/lib/mysql' --user=root && tail -F /var/log/mariadb/mariadb.log



