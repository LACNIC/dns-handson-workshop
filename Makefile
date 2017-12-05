# Makefile para ejecutar el ambiente

build: Dockerfile
	docker build -t lacnic_bind9 .

network: 
	docker network rm dnsworkshop
	docker network create --subnet=172.77.0.0/16 dnsworkshop

sampleshell:
	docker run --net dnsworkshop --ip 172.77.1.4 -ti lacnic_bind9 /bin/bash

clean:
	docker rmi lacnic_bind9
	docker network rm dnsworkshop