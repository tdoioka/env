#!/bin/zsh

if ! type -p pyenv >&/dev/null; then
  source ~/.shrc/pyenv.rc.bash
fi

function pyenv() {
  command pyenv "$@"
}
pyenv "$@"
