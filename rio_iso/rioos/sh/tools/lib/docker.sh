#!/bin/bash

# Copyright 2017 RioCorp Inc.#

DOCKER_VERSION=${DOCKER_VERSION:-17.12.0-ce}

rioos::docker::validate() {
  # validate if in path
  which docker >/dev/null || {
    rioos::log::usage "docker must be in your PATH"
    exit 1
  }

  # validate it is not running
  if pgrep -x docker >/dev/null 2>&1; then
    rioos::log::usage "docker appears to already be running on this machine (`pgrep -xl docker`) (or its a zombie and you need to kill its parent)."
    rioos::log::usage "retry after you resolve this docker error."
    exit 1
  fi

  # validate installed version is at least equal to minimum
  version=$(docker --version | tail -n +1 | head -n 1 | cut -d " " -f 3)
  if [[ $(rioos::docker::version $DOCKER_VERSION) -gt $(rioos::docker::version $version) ]]; then
   hash docker
   version=$(docker --version | head -n 1 | cut -d " " -f 3)
   if [[ $(rioos::docker::version $DOCKER_VERSION) -gt $(rioos::docker::version $version) ]]; then
    rioos::log::usage "docker version ${DOCKER_VERSION} or greater required."
    rioos::log::info "You can use 'docker.sh' to install a copy in shell/sh."
    exit 1
   fi
  fi
}

rioos::docker::version() {
  printf '%s\n' "${@}" | awk -F . '{ printf("%d%03d%03d\n", $1, $2, $3) }'
}

# Start docker daemon
rioos::docker::start() {
  # validate before running
  rioos::docker::validate

  # Start docker
  sudo systemctl restart docker
  sudo systemctl status --no-pager docker

  rioos::log::info "Docker is up and running." >> $LOG
}

rioos::docker::stop() {
  kill "${DOCKER_PID-}" >/dev/null 2>&1 || :
  wait "${DOCKER_PID-}" >/dev/null 2>&1 || :
}

rioos::docker::clean_docker_dir() {
  rm -rf "${DOCKER_DIR-}"
}

rioos::docker::cleanup() {
  rioos::docker::stop
  rioos::docker::clean_docker_dir
}

# Install docker
rioos::docker::install() {
  (
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo apt-get install -y jq

    rioos::log::info "docker v${DOCKER_VERSION} installed." >> $LOG
    rioos::docker::start
  )
}
