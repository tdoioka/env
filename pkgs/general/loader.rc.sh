#!/bin/sh

. "${HOME}/.shrc/funcs.rc.sh"
addpath "${HOME}/bin"

loadshrc() {
  local shname="$(basename $(ps -p $$ -o cmd -h | awk '{print $1}' | tr -d '-'))"
  SHRCS=($(find "${HOME}/.shrc/" -name "*.rc.${shname}" -or -name "*.rc.sh" |
             grep -v "${HOME}/.shrc/funcs.rc.sh" |
             grep -v "${HOME}/.shrc/loader.rc.sh"))
  if [ -n "${SHRCS[*]}" ]; then
    for rc in "${SHRCS[@]}"; do
      echo "load: $rc" >&2
      source "$rc"
    done
  fi
}

if [[ ! -n "${_RCLOADED-}" ]] || \
       [[ $(cat /proc/$$/comm) != $(cat /proc/$PPID/comm) ]] ; then
  loadshrc
  export _RCLOADED=1
fi
