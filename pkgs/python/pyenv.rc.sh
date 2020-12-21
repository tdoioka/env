#!/bin/sh
. ~/.shrc/funcs.rc.sh

export PYENV_ROOT="$HOME/.pyenv"
addpath "${PYENV_ROOT}/bin"

eval "$(pyenv init -)"

. ~/.shrc/pipenv.rc.sh
