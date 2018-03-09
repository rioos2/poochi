#!/bin/bash

# Copyright 2017 RioCorp Inc.

set -o errexit
set -o nounset
set -o pipefail

# The root of the build/dist directory
RIOOS_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/../.." && pwd -P)"
ARAN_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/../../../aran" && pwd -P)"

source "${RIOOS_ROOT}/tools/lib/util.sh"
source "${RIOOS_ROOT}/tools/lib/logging.sh"
source "${RIOOS_ROOT}/tools/lib/docker.sh"
source "${RIOOS_ROOT}/tools/lib/registry.sh"
source "${RIOOS_ROOT}/tools/lib/probe.sh"
source "${RIOOS_ROOT}/tools/lib/network.sh"
source "${RIOOS_ROOT}/tools/lib/create.sh"
source "${ARAN_ROOT}/tools/localup.sh"

rioos::log::install_errexit
