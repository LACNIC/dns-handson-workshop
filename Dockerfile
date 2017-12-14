# A basic apache server. To use either add or bind mount content under /var/www
# STAGE #1 compile bind 9

FROM ubuntu:16.04 as Bind9Builder
MAINTAINER carlos@xt6.us
WORKDIR /root
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


# 
FROM ubuntu:16.04
MAINTAINER carlos@lacnic.net, version: 0.1
RUN apt-get update && apt-get install -y iputils-ping dnsutils binutils openssh-server net-tools libssl1.0.0 openssh-server
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# set root password
RUN mkdir /var/run/sshd && echo 'root:screencast' | chpasswd && echo "export VISIBLE=now" >> /etc/profile
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir /dfiles
COPY --from=Bind9Builder /root/bind9.10.tar.gz /root
RUN cd / && tar xzvf /root/bind9.10.tar.gz  && rm /root/bind9.10.tar.gz

# Add non-root user
RUN useradd -m named

# CMD ["/opt/bind9.10/sbin/named", "-g", ""]
CMD ["/bin/bash", "", ""]
