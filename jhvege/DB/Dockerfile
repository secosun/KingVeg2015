FROM centos:7
ENV rootpasswd 123456 
RUN yum -y install mariadb mariadb-server \
   && systemctl enable mariadb
COPY mysqlinit.txt /
COPY jingheproduct.sql /
COPY mysql.sh /
RUN mysql_install_db  --user=mysql 
CMD mysqld_safe --datadir='/var/lib/mysql' & sleep 3 \
   && echo -e "\nY\n$rootpasswd\n$rootpasswd\nn\nn\nn\nn\n"  | mysql_secure_installation \
   && mysql -uroot -p$rootpasswd < mysqlinit.txt \
   && chmod +x mysql.sh \
   && ./mysql.sh \
   && tail -f /var/log/mariadb/mariadb.log

