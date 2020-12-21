#!/bin/sh

alias bb='bitbake'
function _bb_task() {
  local task="$1"
  shift
  local args=()
  for rr in "$@"; do
    args=("${args[@]}" "${rr}:${task}")
  done
  if [ -n "${args[*]}" ]; then
    echo "@@@@ bitbake ${args[@]}"
  fi
  bitbake "${args[@]}"
}
function bbc() {
  _bb_task "do_clean" "$@"
}
function bbca() {
  _bb_task "do_cleanall" "$@"
}
function bbr() {
  if [ -n "$1" ]; then
    echo "@@@@ bitbake -c clean $1 && bitbake $@"
    bitbake -c clean "$1" && bitbake "$@"
  fi
}
function bbcr() {
  if [ -n "$1" ]; then
    echo "@@@@ bitbake -c cleanall $1 && bitbake $@"
    bitbake -c cleanall "$1" && bitbake "$@"
  fi
}
function bbrmc() {
  if [ -n "${BUILDDIR}" ]; then
    echo "rm -rf ${BUILDDIR}/{tmp,cache}"
    rm -rf "${BUILDDIR}"/{tmp,cache}
  fi
}
function bbenv() {
  if [ -n "$1" ]; then
    echo "@@@@ bitbake -e $1 > $1.env.py"
    bitbake -e "$1" > "${2:-$1.env.py}"
  fi
}
alias bbls='bitbake-layers'
alias bbsr='bitbake-layers show-recipes'
