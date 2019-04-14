#!/bin/bash

set_install_env

aptinstallifneed git

linkifneed ${S}/gitconfig.d ~/.gitconfig.d
touch ~/.gitconfig.d/user.conf
linkifneed ${S}/gitconfig.d/gitconfig ~/.gitconfig
