# A basic apache server. To use either add or bind mount content under /var/www
FROM ubuntu:16.04

MAINTAINER Carlos M. Martinez, version: 0.1

RUN apt-get update  
RUN apt-get install -y bind9 bind9-doc bind9-host bind9utils
RUN apt-get install -y iputils-ping dnsutils
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /dfiles

# ENV APACHE_RUN_USER www-data
# ENV APACHE_RUN_GROUP www-data
# ENV APACHE_LOG_DIR /var/log/apache2

# VOLUME ["/dfiles"]

EXPOSE 5353

CMD ["/usr/sbin/named", "-g", ""]