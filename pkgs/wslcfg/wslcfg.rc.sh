#!/bin/sh
. ~/.shrc/funcs.rc.sh

if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  addapth "/mnt/c/Program\ Files/Oracle/VirtualBox/"
  addpath "/mnt/c/Windows/System32/"
  addpath "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/"
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
  export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/d/virtualbox"
  export VAGRANT_WSL_WINDOWS_ACCESS_USER="$(cmd.exe /C echo %username% 2>/dev/null)"
  type -p vboxmanage || {
    alias vboxmange='VBoxManage.exe'
  }
fi
