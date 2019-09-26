#!/bin/bash

set_install_env
install_depend general

# install pyenv
#................................................................
gitclone "git://github.com/yyuu/pyenv.git"
linkifneed "${B}" ~/.pyenv

aptinstallifneed make
aptinstallifneed build-essential
aptinstallifneed libssl-dev
aptinstallifneed zlib1g-dev
aptinstallifneed libbz2-dev
aptinstallifneed libreadline-dev
aptinstallifneed libsqlite3-dev
aptinstallifneed wget
aptinstallifneed curl
aptinstallifneed llvm
aptinstallifneed libncurses5-dev
aptinstallifneed libncursesw5-dev
aptinstallifneed xz-utils
aptinstallifneed tk-dev

linkifneed "${S}/pyenv.sh" ~/.shrc.d/pyenv.sh

# install python on pyenv
#................................................................
aptinstallifneed libffi-dev

source ~/.shrc.d/pyenv.sh

function pyenv_install() {
    if [[ -z "$(pyenv versions | grep -ow "${1}" 2>/dev/null)" ]]; then
	(export CFLAGS=-I/usr/include/openssl;
	 export LDFLAGS=-L/usr/lib;
	 pyenv install -v "${1}")
    fi
}

# pyenv_install 3.7.2
pyenv_install 3.6.7
pyenv global 3.6.7
echo "PYENV: $(pyenv versions | grep -e '^\*')"
