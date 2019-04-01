#!/bin/bash

set_install_env

aptinstallifneed zsh

linkifneed "${S}/zshrcd" ~/.zshrc.d
linkifneed "${S}/zshrcd/zshrc.zsh" ~/.zshrc

if [[ "$(uname)" == "Linux" ]]; then
    sudo chsh $(whoami) -s $(which zsh)
fi

install_depend zaw
