# Use from bash or zsh by source command.
. ~/.shrc/funcs.rc.sh

# setup  pyenv
export PYENV_ROOT="$HOME/.pyenv"
addpath "${PYENV_ROOT}/bin"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# disable virtual-env prompt display
export VIRTUAL_ENV_DISABLE_PROMPT=1
# pipenv use pyenv python.
export PIPENV_PYTHON="${PYENV_ROOT}/shims/python"

function __python::isbin() {
  type -p $1 >&/dev/null && which $1 >&/dev/null
}

# autoload pipenv
function pipenv() {
  if pyenv version >&/dev/null; then
    if ! __python::isbin pipenv; then
      addpath "$(python -m site --user-base)/bin"
      if eval "$(command pipenv --completion)"; then
        function pipenv () {
          command pipenv "$@"
        }
      fi
    fi
    command pipenv "$@"
  fi
}
