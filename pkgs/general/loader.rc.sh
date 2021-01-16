#!/bin/sh

. "${HOME}/.shrc/funcs.rc.sh"
addpath "${HOME}/bin"

loadshrc() {
  local shname="$(basename $(ps -p $$ -o cmd -h | awk '{print $1}' | tr -d '-'))"
  SHRCS=($(find "${HOME}/.shrc/" -name "*.rc.${shname}" -or -name "*.rc.sh" |
             grep -v "${HOME}/.shrc/funcs.rc.sh" |
             grep -v "${HOME}/.shrc/loader.rc.sh"))
  if [ -n "${SHRCS[*]}" ]; then
    local ts_bef ts_now ts_start
    ts_start=$(date +%s.%N)
    for rc in "${SHRCS[@]}"; do
      local ts_bef=${ts_now:-$(date +%s.%N)}
      source "$rc"
      ts_now=$(date +%s.%N)
      echo -e "load: $rc\t[$(bc <<< "scale=6; ($ts_now - $ts_bef) / 1")]" >&2
    done
    echo "total: $(bc <<< "scale=6; ($ts_now - $ts_start) / 1") sec" >&2
  fi
}

if [[ ! -n "${_RCLOADED-}" ]] || \
       [[ $(cat /proc/$$/comm) != $(cat /proc/$PPID/comm) ]] ; then
  loadshrc
  export _RCLOADED=1
fi
