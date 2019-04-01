#!/bin/bash

set_install_env
install_depend general

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
