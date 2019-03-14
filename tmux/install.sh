#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed tmux

linkifneed ${S}/tmux.conf ~/.tmux.conf
