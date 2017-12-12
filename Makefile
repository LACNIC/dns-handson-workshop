# Makefile para ejecutar el ambiente
# (c) carlos@lacnic.net, 20171205

IMAGE = dnsworkshop:bind9
NAMEDPFX = /opt/bind9.10
STDGROUPS = group0 group1 group2 group3 group4 group5

help:
	echo "Usage: make build|network|rootshell|clean"

build: Dockerfile
	docker build -t lacnic_bind9 .

network: 
	- docker network rm dnsworkshop
	docker network create --subnet=172.77.0.0/16 dnsworkshop

clonegroups:
	@for G in $(STDGROUPS); do \
		echo Creating $$G; \
		cp -Rvp dfiles/bind9/stdgroup/base dfiles/bind9/$$G; \
	done

cleangroups:
	@for G in $(STDGROUPS); do \
		echo Cleaning $$G; \
		docker rm --force $$G; \
		rm -rf dfiles/bind9/$$G; \
	done

startgroups:
	@for G in $(STDGROUPS); do \
		echo Starting named for $$G; \
		docker rm $$G; \
		docker run --net dnsworkshop --dns=172.77.0.2 -d -v $$(pwd)/dfiles/bind9/$$G:/bind9 \
	   		--name=$$G $(IMAGE) \
	   		$(NAMEDPFX)/sbin/named -c /bind9/named.conf -g; \
	done

enableroot:
	echo Enabling A.ROOT-LOC.
	- docker rm --force dnswk_aroot
	- docker run --net dnsworkshop --dns=172.77.0.2 --ip 172.77.0.2 -d -v $$(pwd)/dfiles/bind9/pri_rootserver:/bind9 \
	   --name=dnswk_aroot $(IMAGE) \
	   $(NAMEDPFX)/sbin/named -c /bind9/named.conf -g
	#
	echo Enabling B.ROOT-LOC.
	- docker rm --force dnswk_broot
	- docker run --net dnsworkshop --dns=172.77.0.3 --ip 172.77.0.3 -d -v $$(pwd)/dfiles/bind9/sla_rootserver:/bind9 \
	   --name=dnswk_broot $(IMAGE) \
	   $(NAMEDPFX)/sbin/named -c /bind9/named.conf -g

shell:
	docker run --net dnsworkshop --dns=172.77.0.2 --ip 172.77.255.254 -ti  --hostname="dnshost" \
	   -v $$(pwd)/dfiles/bind9:/bind9 \
	   $(IMAGE) \
	   /bin/bash

stop:
	docker stop dnswk_aroot dnswk_broot
	docker rm dnswk_aroot dnswk_broot

clean:
	# docker rmi lacnic_bind9
	docker network rm dnsworkshop