#!/bin/sh
. ~/.shrc/funcs.rc.sh

export PYENV_ROOT="$HOME/.pyenv"
addpath "${PYENV_ROOT}/bin"

if type pyenv >&/dev/null; then
  eval "$(pyenv init -)"
  if [[ -f ~/.shrc/pipenv.rc.sh ]]; then
    . ~/.shrc/pipenv.rc.sh
  fi
else
  echo "skip setup pyenv"
fi
