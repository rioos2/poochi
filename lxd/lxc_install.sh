#!/bin/bash

# exit on any error
set -e

BUILDDIR=build/xenial
API_DEPENDENCIES=("postgresql libcurl4-openssl-dev")
UI_DEPENDENCIES=""
COMMANDCENTER_DEPENDENCIES=""
VNC_DEPENDENCIES=""
METRICS_DEPENDENCIES=""
CONTROLLER_DEPENDENCIES=""
NODELET_DEPENDENCIES=""

parse_params() {
  while
  (( $# > 0 ))
  do
    token="$1"
    shift
    case "$token" in
      (--repo)
      repo="$1"
      if [ -z "$repo" ]
      then
        usage
        exit
      fi
      shift
    ;;
    (help|usage)
    usage
    exit 0
  ;;
  (*)
  usage
  exit 0
;;
esac
  done
}

usage() {
  echo "List of Repositories"
  echo "  rioos-apiserver"
  echo "  rioos-ui"
  echo "  rioos-commandcenter"
  echo "  rioos-vnc"
  echo "  rio-metricsserver"
  echo "  rioos-controller"
  echo "  rioos-nodelet"
  echo "  Options:"
  echo "--repo <repo directory> "
  echo "--help"
  echo
}

function rioos_common(){
  lxc launch ubuntu:16.04 $repo
  sleep 10
  echo "Install dependencies"
  lxc exec $repo -- sed -i '/ubuntu xenial-updates universe/d' /etc/apt/sources.list
  lxc exec $repo -- apt-get update -y
  lxc exec $repo -- apt-get install -y libsodium-dev
  lxc exec $repo -- apt-get install -y libarchive-dev
}

function install_dependencies(){
  case "${repo}" in
    rioos-apiserver)
      install_dep ${API_DEPENDENCIES[@]}
    ;;
    rioos-ui)
      install_dep ${UI_DEPENDENCIES[@]}
    ;;
    rioos-commandcenter)
      install_dep ${COMMANDCENTER_DEPENDENCIES[@]}
    ;;
    rioos-vnc)
      install_dep ${VNC_DEPENDENCIES[@]}
    ;;
    rio-metricsserver)
      echo $repo
      install_dep ${METRICS_DEPENDENCIES[@]}
    ;;
    rioos-controller)
      install_dep ${CONTROLLER_DEPENDENCIES[@]}
    ;;
    rioos-nodelet)
      install_dep ${NODELET_DEPENDENCIES[@]}
    ;;
    *)
      echo "Unknown Repositories: ${repo}." >&2
      echo "Repositories are: rioos-apiserver rioos-ui rioos-commandcenter rioos-vnc rio-metricsserver rioos-controller rioos-nodelet." >&2
  esac
}

function install_dep(){
  for dep in $@
  do
    lxc exec testing -- apt-get install -y $dep
  done
  if [ $repo = "rioos-apiserver" ]
  then
    psql_configuration
  fi
}

function psql_configuration(){
  lxc file push --create-dirs psql.sh  testing/var/lib/postgresql/
  lxc exec testing -- sudo -u postgres psql -f /var/lib/postgresql/psql.sh
  lxc exec testing -- sed -i 's/local   all             all                                     peer/local   all             all                                     md5/g' /etc/postgresql/9.5/main/pg_hba.conf
  lxc exec testing -- systemctl restart postgresql
}

function create_lxd_tarball(){
  REPO=$(echo $repo | sed 's/_//')
  lxc file push --create-dirs ./../$repo/$BUILDDIR/*.deb  testing/var/lib/rioos/
  lxc exec $repo -- apt-add-repository "deb [arch=amd64] http://192.168.2.47/repo/2.0/ubuntu/16.04/testing xenial testing"
  lxc exec $repo -- apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9B46B611
  lxc exec $repo -- apt-get update -y
#  dpkg -i /var/lib/rioos/$REPO"_2.0-1_amd64.deb"
  lxc exec $repo -- apt-get install -y $repo
  lxc publish $repo --alias $repo -f --public=true
  lxc image export $repo ./../$repo/$BUILDDIR/$repo.tar.gz
}

start() {
  parse_params "$@"
  if [ -z "$repo" ]
  then
    echo "You are not mentioned any Repositories."
  else
    rioos_common
    install_dependencies
    create_lxd_tarball
  fi
}

start "$@"
