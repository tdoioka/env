#!/bin/sh
. ~/.shrc/funcs.rc.sh

if type python >&/dev/null; then
  addpath "$(python -m site --user-base)/bin"
  if type pipenv >&/dev/null; then
    # setup pipenv
    eval "$(pipenv --completion)"
    # disable virtual-env prompt display
    export VIRTUAL_ENV_DISABLE_PROMPT=1
  else
    echo "skip setup pipenv"
  fi
fi
