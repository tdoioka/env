#!/bin/zsh

if ! type -p pipenv >&/dev/null; then
  source ~/.shrc/pipenv.rc.bash
fi

function pipenv() {
  command pipenv "$@"
}
pipenv "$@"
