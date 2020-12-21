#!/bin/bash

set -ueo pipefail

CDR="$(dirname "$0")"
PKGSD="${CDR}/pkgs"

source "$PKGSD/path.conf"

function aptinstall() {
  sudo apt-get install -qq -y --no-install-recommends "$@" >/dev/null
}

function ptouch() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

function init_install() {
  local log="${PKGSD}/${LOGD}/setup.sh.log"
  local done="${PKGSD}/${CACHED}/${UPDATED}"
  mkdir -p $(dirname ${log}) $(dirname ${done})
  if type apt-get ; then
    # when make is not exists need update and install.
    if ! dpkg -L make &>/dev/null; then
      echo "INFO: Insatll make ..."
      ptouch "$log"
      sudo apt-get -qq update >> "$log"
      sudo apt-get -qq upgrade -y >> "$log"
      ptouch "$done"
      aptinstall make
    fi
    return 0
  fi
  return 1
}
CPU="$(grep -e '^proc' /proc/cpuinfo | wc -l)"

init_install
make -C "$PKGSD" -j "${CPU}" "$@"
