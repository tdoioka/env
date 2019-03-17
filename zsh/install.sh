#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed zsh

linkifneed "${S}/zshrcd" ~/.zshrc.d
linkifneed "${S}/zshrcd/zshrc.zsh" ~/.zshrc

if [[ "$(uname)" == "Linux" ]]; then
    sudo chsh $(whoami) -s $(which zsh)
fi

bash "${S}/zaw/subinstall.sh"
