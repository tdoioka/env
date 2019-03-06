#!/bin/bash

sudo apt install -y tmux

source $(realpath `dirname $0`/../lib/libs.sh)

aresame ./tmux.conf ~/.tmux.conf || {
	ln --backup=t -s $(realpath ./tmux.conf) ~/.tmux.conf
}
