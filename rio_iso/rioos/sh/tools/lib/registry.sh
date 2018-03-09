#!/bin/bash

# Copyright 2017 RioCorp Inc.#

# Variable creation
CERT_FILE=/var/lib/ca.crt
DOCKER_DIR=/etc/docker/certs.d/registry.megam.io:5000
REGISTRY_URL=registry.megam.io:5000
REGISTRY_USER=rioosadmin
REGISTRY_PASS=team4rio
REGISTRY_DIR=/var/lib/rioos/containers
REGISTRY_KEYS=$REGISTRY_DIR/certs
REGISTRY_AUTH=$REGISTRY_DIR/auth
LOCAL_REGISTRY=registry.local.io:5000
REGISTRY_CERT=/etc/docker/certs.d/$LOCAL_REGISTRY

# Connect to Rio/OS private registry
function rioos::docker::registry {
  mkdir -p $DOCKER_DIR
  echo $REGISTRY_PASS > $PWD/my_password.txt
  cp $CERT_FILE $DOCKER_DIR

  # Connect with private registry
  result=$(cat $PWD/my_password.txt | sudo docker login $REGISTRY_URL -u $REGISTRY_USER --password-stdin)

  if [ "$result" = "Login Succeeded" ]
  then
    sudo rm -f $PWD/my_password.txt
    rioos::log::info "Successfully login into Rio/OS private registry" >> $LOG
  else
    rioos::log::info "Error in Rio/OS private registry login" >> $LOG
  fi
}

function rioos::setup::registry_common {
  mkdir -p $REGISTRY_KEYS $REGISTRY_AUTH $REGISTRY_CERT
}

# function rioos::setup::private_registry {
#
# }
