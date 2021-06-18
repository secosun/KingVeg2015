FROM centos:7
COPY nginx.repo   /etc/yum.repos.d/nginx.repo
COPY default.conf /etc/nginx/conf.d/
RUN yum install epel-release -y \
    && yum update -y \
    && yum -y install yum-utils \
    && yum install nginx -y
EXPOSE 80
EXPOSE 443
CMD nginx \
   && tail -f --retry /var/log/nginx/access.log
