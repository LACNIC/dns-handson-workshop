# A basic apache server. To use either add or bind mount content under /var/www
# STAGE #1 compile bind 9

FROM ubuntu:16.04 
LABEL MAINTAINER="carlos@xt6.us"
WORKDIR /root
RUN echo 'Acquire::http::Proxy "http://trantor.labs.lacnic.net:9999";' > /etc/apt/apt.conf.d/00aptproxy
RUN apt-get update && apt-get install -y libssl-dev build-essential
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN wget -q --output-document=bind.tar.gz ftp://ftp.isc.org/isc/bind9/9.10.2/bind-9.10.2.tar.gz
COPY bind.tar.gz /root
RUN mkdir -p /root/bind && tar xzvf /root/bind.tar.gz -C /root/bind --strip-components=1
WORKDIR /root/bind
RUN ./configure --disable-linux-caps --prefix=/opt/bind9.10 && make && make install && ln -sf /opt/bind9.10 /opt/bind9
# COPY rndc.conf /opt/bind9.10/etc
ADD http://www.internic.net/domain/named.root /opt/bind9.10/etc/named.root
RUN tar czvf /root/bind9.10.tar.gz /opt/bind9.10
