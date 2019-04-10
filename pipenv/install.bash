#!/bin/bash

set_install_env
install_depend general
install_depend python

if [[ -z $(pip list | sed 1,2d |
	       awk '{print $1}' |
	       grep -wie "^pipenv$") ]]; then
    pip install --upgrade pip >& /dev/null
    pip install --user --upgrade pipenv
fi

linkifneed "${S}/pipenv.sh" ~/.shrc.d/pipenv.sh

