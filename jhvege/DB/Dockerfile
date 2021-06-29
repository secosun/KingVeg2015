FROM alpine:3.12.0
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV rootpasswd 123456 
RUN apk add --no-cache mysql mysql-client
COPY mysqlinit.txt /
COPY jingheproduct.sql /
COPY mysql.sh /
COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN mysql_install_db  --user=mysql --ldata=/var/lib/mysql
#RUN mkdir -p /run/mysqld && \
#    chown -R mysql:mysql /run/mysqld && \
#    chown -R mysql:mysql /var/lib/mysql && \
#    mysql_install_db  --user=mysql --ldata=/var/lib/mysql
#    cp /usr/share/mariadb/mysql.server /etc/init.d/mysql.server
CMD mysqld_safe --datadir='/var/lib/mysql' & sleep 3 \
   && echo -e "\nY\n$rootpasswd\n$rootpasswd\nn\nn\nn\nn\n"  | mysql_secure_installation \
   && mysql -uroot -p$rootpasswd < mysqlinit.txt \
   && chmod +x mysql.sh \
   && ./mysql.sh \
   && tail -F /var/log/mariadb/mariadb.log



