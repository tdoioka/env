#!/bin/bash

set_install_env

install_depend pyenv

aptinstallifneed zlib1g-dev
aptinstallifneed libbz2-dev
aptinstallifneed libreadline-dev
aptinstallifneed libffi-dev

source ~/.shrc.d/pyenv.sh

function pyenv_install() {
    if [[ -z "$(pyenv versions | grep -ow "${1}" 2>/dev/null)" ]]; then
	(export CFLAGS=-I/usr/include/openssl;
	 export LDFLAGS=-L/usr/lib;
	 pyenv install -v "${1}")
    fi
}
pyenv_install 3.7.2
pyenv_install 3.6.7
pyenv versions
pyenv global 3.6.7

pip install --upgrade pip
