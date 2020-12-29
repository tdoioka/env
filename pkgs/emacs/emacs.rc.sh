#!/bin/sh

source ~/.libsh/shlog

emacslog=~/.emacs.d/log

if ! type edinit &>/dev/null; then
  _edinit() {
    shlog qR ~/.emacs.d/log
    if ! pgrep '^emacs$' > /dev/null ; then
      echo "START: emacs daemon" 1>&2
      emacs --daemon
    fi
  }
  edinit() {
    (_edinit)
  }
fi

if ! type edkill &>/dev/null; then
  _edkill() {
    shlog qR ~/.emacs.d/log
    if pgrep '^emacs$' > /dev/null; then
      echo 'KILL: emacs daemon' 1>&2
      emacsclient -e '(kill-emacs)'
    fi
  }
  edkill() {
    (_edkill)
  }
fi

# start up emacs daemon
edinit
# set alias to emacs client
# alias e='emacsclient -t -a ""'
e () {
  if ! emacsclient -e 0 > /dev/null 2>&1; then
    edinit
  fi
  emacsclient -t -a "" "$@"
}

alias sue='sudo emacsclient -t -a ""'
if ! type suedkill &>/dev/null ; then
  _suedkill() {
    shlog qR ~/.emacs.d/log
    if pgrep '^emacs$' > /dev/null; then
      echo 'KILL: emacs daemon' 1>&2
      sudo emacsclient -e '(kill-emacs)'
    fi
  }
  suedkill() {
    (_suedkill)
  }
fi

# default editor
export EDITOR='e'

if [ -z "${DISPLAY:-}" ]; then
  export DISPLAY=:0
fi
