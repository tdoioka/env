#!/bin/bash

sudo apt install -y tmux

source $(realpath `dirname $0`/../lib/libs.sh)

linkifneed ${S}/tmux.conf ~/.tmux.conf
