# setup pipenv PATH
pipenv_path="$(python -m site --user-base)/bin"
[[ $PATH =~ .*${pipenv_path}.* ]] || {
    export PATH="${PATH}:${pipenv_path}"
}
# setup pipenv
eval "$(pipenv --completion)"

# disable virtual-env prompt display
export VIRTUAL_ENV_DISABLE_PROMPT=1
