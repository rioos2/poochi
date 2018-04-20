#!/bin/bash

# Copyright 2017 RioCorp Inc.#

Compute="rioos-fluentbit rioos-nodelet"
Storage="rioos-storlet"
repo_url="registry.rioos.xyz"
distro="rioos"
distroversion=$VERSION
distroname="aventura"
release="testing"

# Get docker images from Private Registry
rioos::pull::images() {
  for RIOOS_IMAGE in ${RIOOS_IMAGES[@]}
  do
    docker pull $REGISTRY_URL/$RIOOS_IMAGE
    rioos::log::info "Rio/OS $RIOOS_IMAGE successfully downloaded from registry" >> $LOG
  done
}

# Run Rio/OS docker container
rioos::run:container() {
  RIOOS_IMAGE=$2
  LINK=$3
  ENV_VAR=$4
  PORT=$5
  VOLUME=$6
  CACHE=$7

  RIO_IMAGE=${RIOOS_IMAGE//[[:digit:]]/}
  RIO_IMAGE=$(echo "$RIO_IMAGE" | sed 's/[\:._-]//g')

  # Container create
  docker run -d --name=$RIO_IMAGE $LINK $ENV_VAR $PORT $VOLUME --restart always $REGISTRY_URL/$RIOOS_IMAGE $CACHE
  rioos::log::info "$RIO_IMAGE container create and its running" >> $LOG
}

function  rioos::common {
  sed -i "s/'Rio\/OS v2 GNU\/Linux'/Rio\/OS v2/g" /boot/grub/grub.cfg
  sed -i "s/'Advanced options for Rio\/OS v2 GNU\/Linux'/Advanced options for Rio\/OS v2/g" /boot/grub/grub.cfg
  mkdir -p $RIOOS_HOME/config/pullcache $RIOOS_HOME/pgdata $RIOOS_HOME/influxdb
  wget -O $RIOOS_HOME/config/api.toml https://gitlab.com/rioos/aran/raw/2-0-stable/tools/config/api.toml?private_token=JgH4PaKVpuJM3yRidaS9
  sudo apt-get update -y
  sudo apt-get install -y software-properties-common python-software-properties
}


# Test whether docker is installed.
# Sets:
#  OPENSSL_BIN: The path to the docker binary to use
function rioos::util::test_docker_installed {
  DOCKER_BIN=""
  DOCKER_BIN=$(command -v docker)
}

rioos::update::repo() {
  sudo apt-add-repository "deb [arch=amd64] https://$repo_url/repo/$distro/$distroname/$distroversion/$release $distroname $release"
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 02789828
  sudo apt-get -y update
  rioos::create::bootstrap_config
}

# Install Compute
rioos::install::compute() {
 sudo apt-get install -y $Compute
}

# Install Storage
rioos::install::storage() {
 sudo apt-get install -y $Storage
}

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  declare -r color_start="\033["
  declare -r color_red="${color_start}0;31m"
  declare -r color_yellow="${color_start}0;33m"
  declare -r color_green="${color_start}0;32m"
  declare -r color_norm="${color_start}0m"
fi
