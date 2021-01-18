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
      printf "load: %-40.40s[%8.6f]\n" "$rc" "$(bc <<< "$ts_now - $ts_bef")" >&2
    done
    printf "total: %8.6f sec\n" "$(bc <<< "$ts_now - $ts_start")" >&2
  fi
}

if [[ ! -n "${_RCLOADED-}" ]] || \
       [[ $(cat /proc/$$/comm) != $(cat /proc/$PPID/comm) ]] ; then
  loadshrc
  export _RCLOADED=1
fi
