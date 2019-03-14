#!/bin/bash

source "$(realpath `dirname $0`/../../lib/libs.sh)"

gitclone "https://github.com/zsh-users/zaw.git"

linkifneed "${S}/zawrc" ~/.zshrc.d/sub/zawrc
