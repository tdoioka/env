#!/bin/sh
. ~/.shrc/funcs.rc.sh

if type python >&/dev/null; then
  addpath "$(python -m site --user-base)/bin"
  # setup pipenv
  eval "$(pipenv --completion)"
  # disable virtual-env prompt display
  export VIRTUAL_ENV_DISABLE_PROMPT=1
fi
