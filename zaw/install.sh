#!/bin/bash

source "$(realpath `dirname $0`/../../lib/libs.sh)"

gitclone "https://github.com/zsh-users/zaw.git"

linkifneed "${S}/zawrc.zsh" ~/.zshrc.d/sub/zawrc.zsh
linkifneed "${B}/zaw.zsh" ~/.zshrc.d/sub/zaw.zsh
