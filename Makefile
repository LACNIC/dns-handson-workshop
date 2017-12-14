# Makefile para ejecutar el ambiente
# (c) carlos@lacnic.net, 20171205

IMAGE = dnsworkshop:bind9
NAMEDPFX = /opt/bind9.10
STDGROUPS = group0a group0b group1a group1b group2a group2b group3a group3b group4a group4b group5a group5b

help:
	@echo "Usage: "
	@echo " 	make build: builds docker images"
	@echo "	make network: creates private network"
	@echo "	make clonegroups: clones each student group files"
	@echo "	make cleangroups: removes (rm -rf) each student group folder"

build: Dockerfile
	wget -cN --output-document=bind.tar.gz http://ftp.isc.org/isc/bind9/9.10.2/bind-9.10.2.tar.gz
	docker build -t dnsworkshop:bind9 .

network: 
	-docker network rm dnsworkshop
	docker network create --subnet=172.77.0.0/16 --ip-range=172.77.1.0/24 dnsworkshop

clonegroups:
	@for G in $(STDGROUPS); do \
		echo Creating $$G; \
		cp -Rfp dfiles/bind9/stdgroup/base dfiles/bind9/$$G; \
	done

cleangroups:
	@for G in $(STDGROUPS); do \
		echo Cleaning $$G; \
		docker rm --force $$G; \
		rm -rf dfiles/bind9/$$G; \
	done

# startgroups:
# 	@for G in $(STDGROUPS); do \
# 		echo Starting named for $$G; \
# 		docker rm --force $$G; \
# 		docker run --net dnsworkshop --dns=172.77.0.2 -d -v $$(pwd)/dfiles/bind9/$$G:/bind9 \
# 	   		--name=$$G $(IMAGE) \
# 	   		$(NAMEDPFX)/sbin/named -c /bind9/named.conf -g; \
# 	done

enableroot:
	echo Enabling A.ROOT-LOC.
	- docker rm --force dnswk_aroot
	- docker run --net dnsworkshop --dns=172.77.0.2 --ip 172.77.0.2 -d -v $$(pwd)/dfiles/bind9/pri_rootserver:/bind9 \
	   --name=dnswk_aroot --hostname=aroot $(IMAGE) \
	   $(NAMEDPFX)/sbin/named -c /bind9/named.conf -g
	#
	echo Enabling B.ROOT-LOC.
	- docker rm --force dnswk_broot
	- docker run --net dnsworkshop --dns=172.77.0.3 --ip 172.77.0.3 -d -v $$(pwd)/dfiles/bind9/sla_rootserver:/bind9 \
	   --name=dnswk_broot --hostname=broot $(IMAGE) \
	   $(NAMEDPFX)/sbin/named -c /bind9/named.conf -g

stoproot:
	@echo Stopping root server system
	@docker rm --force dnswk_aroot
	@docker rm --force dnswk_broot

rootshella:
	docker exec -ti \
	   dnswk_aroot \
	   /bin/bash

rootshellb:
	docker exec -ti \
	   dnswk_broot \
	   /bin/bash

stop:
	docker stop dnswk_aroot dnswk_broot
	docker rm dnswk_aroot dnswk_broot

clean:
	# docker rmi lacnic_bind9
	docker network rm dnsworkshop
