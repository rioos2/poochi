#!/bin/bash

# Copyright 2017 The RioCorp Inc Authors.#
RIOOS_HOME=/var/lib/rioos
RIO_FILE=/var/lib/rioos.txt
RIOOS_ROOT=$(dirname "${BASH_SOURCE}")/..
LOG=/var/log/rioos_install.log
VOLUME=${RIOOS_HOME:-"/var/lib/rioos"}
REGISTRY_URL=registry.rioos.xyz:5000
RIOOS_IMAGES=('rioospostgres:10.1' 'rioospowerdns:4.0.3' 'rioosprometheus:2.0' 'rioosui:2.0' 'rioosvnc:2.0' 'riooscontroller:2.0' 'rioosscheduler:2.0' 'rioosinfluxdb:1.3.7')

# Stop right away if the build fails
set -e

source "${RIOOS_ROOT}/tools/lib/init.sh"

# Connect to Private Registry
function connect_registry {
  rioos::log::info "Connecting to Rio/OS private registry" >> $LOG
  rioos::docker::registry
}

# Test PowerDNS is running
function test_dns {
  rioos::dns::test_dns_running DNS_IP
  rioos::log::info $DNS_IP
}

# Create common repositries
function rioos_common {
  rioos::common
}

# Create DNS record in PowerDNS
function create_dns_record {
  sleep 30
  rioos::dns::create_domain
  rioos::find::ipaddress
}

# Pull docker images from Private Registry
function pull_images {
  rioos::log::info "Pull Rio/OS images from Private Registry" >> $LOG
  rioos::pull::images $REGISTRY_URL $RIOOS_IMAGES
}

# Run container from Rio/OS images
function run_container {
  rioos::log::info "Create container from Rio/OS docker image" >> $LOG
  val=$(ip route get 8.8.8.8| grep src| sed 's/.*src \(.*\)$/\1/g')
  HOST_IP="$(echo -e "${val}" | sed -e 's/[[:space:]]*$//')"
  sed  -i "1i nameserver $HOST_IP" /etc/resolv.conf
  echo "printf ' * nameserver:     $HOST_IP\n'" >> /etc/update-motd.d/10-help-text
  rioos::log::info "Machine IPaddress $HOST_IP" >> $LOG

  for RIOOS_IMAGE in ${RIOOS_IMAGES[@]}
  do
    case $RIOOS_IMAGE in
      rioospostgres:10.1)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "-e POSTGRES_PASSWORD=supersecret" "" "-v $VOLUME/pg-data:/var/lib/postgresql" ""
      ;;
      rioospowerdns:4.0.3)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "--link rioospostgres:postgres" "-e AUTOCONF=postgres -e PGSQL_USER=postgres -e PGSQL_PASS=supersecret" "-p $HOST_IP:8081 -p $HOST_IP:53:53 -p $HOST_IP:53:53/udp" "" "--cache-ttl=120 --allow-axfr-ips=127.0.0.1"
      ;;
      rioosprometheus:2.0)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:9090:9090" "" ""
      ;;
      rioosui:2.0)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:80:4200" "" ""
      ;;
      rioosvnc:2.0)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:8000:8000" "" ""
      ;;
      riooscontroller:2.0)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:10252:10252" "-v $RIOOS_HOME/controller:$RIOOS_HOME/controller" ""
      ;;
      rioosscheduler:2.0)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:10251:10251" "-v $RIOOS_HOME/scheduler:$RIOOS_HOME/scheduler" ""
      ;;
      rioosinfluxdb:1.3.7)
        rioos::run:container $REGISTRY_URL $RIOOS_IMAGE "" "" "-p $HOST_IP:8086:8086" "-v $RIOOS_HOME/influxdb:/var/lib/influxdb" ""
      ;;
      *)
        rioos::log::info "Unknown container images: $RIOOS_IMAGE" >&2 >> $LOG
    esac
  done
}

# Modify grub configuration
function modify_grub_conf {
  # Rio/OS Configuration
  sed -i 's/GRUB_HIDDEN_TIMEOUT=0/# GRUB_HIDDEN_TIMEOUT=0/g' /etc/default/grub
  sed -i 's/\<quiet splash\>//g' /etc/default/grub
  sed -i.bak 's/^\(GRUB_DISTRIBUTOR=\).*/\1"Rio\/OS v2"/' /etc/default/grub
  sed -i 's/Ubuntu 16.04/Rio\/OS v2/g' /usr/share/plymouth/themes/ubuntu-text/ubuntu-text.plymouth

  # Update grub configuration
  update-grub
}

# Install docker daemon
function docker_install {
  rioos::util::test_docker_installed
  if [ "$DOCKER_BIN" == "" ]; then
    rioos::log::info "Start installing docker" >> $LOG
    rioos::docker::install
  else
    rioos::log::info "Docker already installed" >> $LOG
  fi
}

function print_success {
  rioos::log::info "Rio/OS Infrastructure setup SUCCESS" >> $LOG
  sudo reboot
}

while read name
do
rioos=$name
done < $RIO_FILE

rioos::log::info "Start Rio/OS Install" >> $LOG
if [ "$rioos" == "master" ]; then
  rioos::util::test_openssl_installed
  rioos::util::ensure-cfssl

  modify_grub_conf
  rioos_common
  docker_install

  rioos::log::info "Starting PKI now!" >> $LOG
  set_service_accounts
  start_pkica

  connect_registry
  pull_images
  run_container
  test_dns
  create_dns_record
elif [ "$rioos" == "compute" ]; then
  modify_grub_conf
  rioos_common
  docker_install
  rioos::update::repo
  rioos::install::compute

  rioos::log::info "Start setup networking!" >> $LOG
  rioos::ovs::install
  rioos::ovs::create_bridge
else
  modify_grub_conf
  rioos_common
  docker_install
  rioos::update::repo
  rioos::install::storage
fi

print_success
