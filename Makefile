# Makefile para ejecutar el ambiente
# (c) carlos@lacnic.net, 20171205

help:
	echo "Usage: make build|network|rootshell|clean"

build: Dockerfile
	docker build -t lacnic_bind9 .

network: 
	- docker network rm dnsworkshop
	docker network create --subnet=172.77.0.0/16 dnsworkshop

enableroot:
	docker run --net dnsworkshop --dns=172.17.0.2 --ip 172.77.0.2 -d -v $$(pwd)/dfiles/bind9:/bind9 lacnic_bind9 \
	   /usr/sbin/named -c /bind9/rootserver/named.conf -g

shell:
	docker run --net dnsworkshop --dns=172.17.0.2 --ip 172.77.255.254 -ti  --hostname="dnshost" \
	   -v $$(pwd)/dfiles/bind9:/bind9 lacnic_bind9 \
	   /bin/bash

clean:
	docker rmi lacnic_bind9
	docker network rm dnsworkshop