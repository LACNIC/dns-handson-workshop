# Makefile para ejecutar el ambiente

build: Dockerfile
	docker build -t lacnic_bind9 .

network: 
	- docker network rm dnsworkshop
	docker network create --subnet=172.77.0.0/16 dnsworkshop

rootshell:
	docker run --net dnsworkshop --ip 172.77.0.2 -ti -v $$(pwd)/dfiles/bind9:/bind9 lacnic_bind9 /bin/bash

clean:
	docker rmi lacnic_bind9
	docker network rm dnsworkshop