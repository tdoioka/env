#!/bin/sh

source ~/.libsh/shlog

emacslog=~/.emacs.d/log

if ! type init_emacsd &>/dev/null; then
  _init_emacsd() {
    shlog qR ~/.emacs.d/log
    if ! pgrep '^emacs$' > /dev/null ; then
      echo "START: emacs daemon" 1>&2
      emacs --daemon
    fi
  }
  init_emacsd() {
    (_init_emacsd)
  }
fi

if ! type kill_emacsd &>/dev/null; then
  _kill_emacsd() {
    shlog qR ~/.emacs.d/log
    if pgrep '^emacs$' > /dev/null; then
      echo 'KILL: emacs daemon' 1>&2
      emacsclient -e '(kill-emacs)'
    fi
  }
  kill_emacsd() {
    (_kill_emacsd)
  }
fi

# start up emacs daemon
init_emacsd
# set alias to emacs client
alias e='emacsclient -t -a ""'
alias sue='sudo emacsclient -t -a ""'
# default editor
export EDITOR='emacsclient -t -a ""'

if [ -z "${DISPLAY:-}" ]; then
  export DISPLAY=:0
fi
