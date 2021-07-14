FROM alpine:3.12.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV rootpasswd 123456 
RUN apk add --no-cache 'mariadb=10.4.19-r0' 'mariadb-client=10.4.19-r0'
COPY mysqlinit.txt /
COPY jingheproduct.sql /
COPY mysql.sh /
COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN mysql_install_db  --user=mysql --ldata=/var/lib/mysql

RUN mysqld_safe --datadir='/var/lib/mysql' & sleep 3 \
   && echo -e "\nn\nY\n$rootpasswd\n$rootpasswd\nY\nn\nY\nY\n"  | mysql_secure_installation \
   && mysql -uroot -p$rootpasswd < mysqlinit.txt \
   && chmod +x mysql.sh \
   && ./mysql.sh \
   && killall -9 mysqld_safe
CMD mysqld_safe --datadir='/var/lib/mysql' && tail -F /var/log/mariadb/mariadb.log



