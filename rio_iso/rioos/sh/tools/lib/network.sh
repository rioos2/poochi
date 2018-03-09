#!/bin/bash

# Copyright 2017 RioCorp Inc.#
OVS=openvswitch-switch
Private_bridge=riopriv4
Public_bridge=riopub4

rioos::ovs::install() {
  rioos::log::info "Installing OvS Network" >> $LOG
  sudo apt-get install -y $OVS
  rioos::log::info "Successfully installed OvS Network" >> $LOG
}

rioos::ovs::create_bridge() {
  rioos::log::info "Default bridge creating. ." >> $LOG
  ovs-vsctl add-br $Private_bridge
  ovs-vsctl add-br $Public_bridge
  rioos::log::info "Default bridge created" >> $LOG
  rioos::ovs::connect_interface
}

rioos::ovs::connect_interface() {
  rioos::log::info "Connecting with interface" >> $LOG
  interface=$(route | grep '^default' | grep -o '[^ ]*$')
  array=(${interface//:/ })
  for i in "${!array[@]}"
  do
    private_ip=$(ifconfig ${array[i]} | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | \
      grep -E '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.)')
    rioos::log::info ${array[i]}
    if [ "$private_ip" == "" ]; then
  	 ovs-vsctl add-port $Public_bridge ${array[i]}
    else
  	 ovs-vsctl add-port $Private_bridge ${array[i]}
    fi
  done
  rioos::log::info "Connected with interface" >> $LOG
}
