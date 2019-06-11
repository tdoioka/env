export PYENV_ROOT="$HOME/.pyenv"
[[ $PATH =~ .*${PYENV_ROOT}.* ]] || {
    export PATH="$PYENV_ROOT/bin:$PATH"
}
eval "$(pyenv init -)"
