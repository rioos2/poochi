#!/bin/bash

# Copyright 2017 RioCorp Inc.#

DNS_NAME="rioospowerdns"
Prefix="rioos"
DOMAIN_NAME="svc.local."
DefaultTimeToLease=86400
REPLICATION_TYPE="Native"
NAMESERVER1="ns1.svc.local."
NAMESERVER2="ns2.svc.local."

# Find container IPaddress
function rioos::find::ipaddress {
  for IMAGE in ${RIOOS_IMAGES[@]}
  do
    RIOOS_IMAGE=${IMAGE//[[:digit:]]/}
    RIOOS_IMAGE=$(echo "$RIOOS_IMAGE" | sed 's/[\:._-]//g')
    CONTAINER_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $RIOOS_IMAGE)
    rioos::log::info $RIOOS_IMAGE":"$CONTAINER_IP >> $LOG
    rioos::dns::record $CONTAINER_IP
  done
}

# Test PowerDNS container is Running
function rioos::dns::test_dns_running {
  val=$(docker inspect -f '{{.State.Running}}' $DNS_NAME)
  if $val; then
    rioos::log::info "$DNS_NAME is runnnig" >> $LOG
    DNS_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $DNS_NAME)
  else
    rioos::log::info "$DNS_NAME is not runnnig" >> $LOG
    exit 1
  fi
}

# Create default domain record in PowerDNS
function rioos::dns::create_domain {
  # Create new zone with nameservers
  rioos::log::info "Private DNS domain creating" >> $LOG
  curl -X POST --data '{"name":"'$DOMAIN_NAME'", "kind": "'$REPLICATION_TYPE'", "masters": [], "nameservers": ["'$NAMESERVER1'", "'$NAMESERVER2'"]}' -v -H 'X-API-Key: rioos_api_key' http://$DNS_IP:8081/api/v1/servers/localhost/zones | jq .
  rioos::log::info "Private DNS domain created" >> $LOG
}

# Create DNS record for containers.
function rioos::dns::record {
  rioos::log::info "Start DNS record creation..." >> $LOG
  DN=$(echo "$RIOOS_IMAGE" | sed s/$Prefix/""/)
  NAME=$DN.$Prefix.$DOMAIN_NAME

  curl -X PATCH --data '{"rrsets": [ {"name": "'$NAME'", "type": "A", "ttl": '$DefaultTimeToLease', "changetype": "REPLACE", "records": [ {"content": "'$HOST_IP'", "disabled": false } ] } ] }' -H 'X-API-Key: rioos_api_key' http://$DNS_IP:8081/api/v1/servers/localhost/zones/$DOMAIN_NAME | jq .
  rioos::log::info "DNS record successfully created..." >> $LOG
}
