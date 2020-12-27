#!/bin/sh
. ~/.shrc/funcs.rc.sh

# export GOENV_DISABLE_GOPATH=1
export GOENV_ROOT="$HOME/.goenv"
addpath "$GOENV_ROOT/bin:$PATH"

eval "$(goenv init -)"
