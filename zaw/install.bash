#!/bin/bash

set_install_env

install_depend zsh

gitclone "https://github.com/zsh-users/zaw.git"

linkifneed "${S}/zawrc.zsh" ~/.zshrc.d/sub/zawrc.zsh
linkifneed "${B}/zaw.zsh" ~/.zshrc.d/sub/zaw.zsh
