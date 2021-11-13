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
      aptinstall make lsb-release
    fi
    return 0
  fi
  return 1
}

function check_version() {
  local codename="$(lsb_release -cs)"
  case ${codename} in
    xenial) ;; # Ubuntu 16.04
    bionic) ;; # Ubuntu 18.04
    focal)  ;; # Ubuntu 20.04
    *)
      echo "Not supported OS version : ${codename} !!!"
      if [[ -z "${FORCE:-}" ]] ; then
        echo "If you want to force installation set environment variable \`FORCE=1'."
        return 1
      fi
      ;;
  esac
  return 0
}

: "${CPU:="$(grep -e '^proc' /proc/cpuinfo | wc -l)"}"

init_install
check_version
eval -- make -C "$PKGSD" -j "${CPU}" "${@:-}"
