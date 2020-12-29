#!/bin/bash

set -euo pipefail

sudo pwd > /dev/null

failure() {
  echo "Failed at $1: $2"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

err() {
  echo "$*" >&2
}

err_exit() {
  local ret="$1"
  shift
  err "$*"
  exit "$ret"
}

parse_args() {
  args=()
  while [[ "$#" -ne 0 ]]; do
    case "$1" in
      -l)
        # Use host linked environment option.
        opt_link=1
        shift
        ;;
      -n)
        # No sync option.
        opt_nosync=1
        shift
        ;;
      --)
        shift
        args=("${args[@]}" "$@")
        break
        ;;
      *)
        args=("${args[@]}" "$1")
        shift
        ;;
    esac
  done
}

function aptinstall() {
  sudo apt-get install -qq -y --no-install-recommends "$@" >/dev/null
}

main() {
  parse_args "$@"
  if [[ ! -n "${opt_nosync:-}" ]]; then
    if ! type rsync >& /dev/null ; then
      aptinstall rsync
    fi
    rsync -a --exclude "*~" --exclude "#*" lenv/ env
  fi
  if [[ -n "${opt_link:-}" ]]; then
    env="lenv"
  else
    env="env"
  fi
  local log
  log="log/$(date +%y%m%d.%H%M%S).log"
  mkdir -p "$(dirname "$log")"
  echo ">>>> $env/setup.sh ${args[*]} > $log"
  time "$env/setup.sh" "${args[@]}" 2>&1 | tee -a "$log"
  echo "@@@@ $?"
  times
  # reset environment
  if [[ -e ~/.bash_profile ]]; then
    source ~/.bash_profile
  fi
  if type edkill >&/dev/null; then
    edkill
  fi
  return 0
}

(cd "$(dirname "$0")" && main "$@")
