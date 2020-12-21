#!/bin/sh
. ~/.shrc/funcs.rc.sh

if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  addapth "/mnt/c/Program\ Files/Oracle/VirtualBox/"
  type -p vboxmanage || {
    alias vboxmange='VBoxManage.exe'
  }
fi
