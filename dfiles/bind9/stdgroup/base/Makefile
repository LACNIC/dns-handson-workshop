# ------------------------------
# Local control makefile
# ------------------------------

# el nombre del container es igual al nombre del directorio actual
CNAME = $(shell basename "$$(pwd)")

IMAGE = dnsworkshop:bind9
NAMEDPFX = /opt/bind9.10

help:
	@echo "Usage: make start|stop"

start:
	@echo Starting BIND server $(CNAME)
	-@docker rm --force $(CNAME)
	@docker run --net dnsworkshop --dns=172.77.0.2 --dns=172.77.0.3 -d -v "$$(pwd)":/bind9 \
	 	--hostname=$(CNAME) --name=$(CNAME) $(IMAGE) \
		$(NAMEDPFX)/sbin/named -c /bind9/named.conf -g; \

stop: 
	@echo Stopping BIND server $(CNAME)
	@docker rm --force $(CNAME)

shell: 
	@echo Opening a shell on BIND server $(CNAME)
	@docker exec -ti \
	   $(CNAME) \
	   /bin/bash	
