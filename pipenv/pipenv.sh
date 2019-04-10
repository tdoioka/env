# setup pipenv PATH
export PATH="${PATH}:$(python -m site --user-base)/bin"

# setup pipenv
eval "$(pipenv --completion)"

# disable virtual-env prompt display
export VIRTUAL_ENV_DISABLE_PROMPT=1
