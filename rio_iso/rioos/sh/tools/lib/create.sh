#!/bin/bash

# Copyright 2017 RioCorp Inc.#
rioos::create::bootstrap_config() {
  rioos::log::info "Create bootstrap config file" >> $LOG
sudo cat >> /var/lib/rioos/config/bootstrap.rioconfig <<EOF
{
   "api_version": "v1",
   "kind": "Config",
   "token": "bootstrap_token_0503",
   "api_server": {
    "server_address":"apiserver.rioos.svc.local",
    "port": 7443,
    "protocol":"http",
   }
}
EOF
}
