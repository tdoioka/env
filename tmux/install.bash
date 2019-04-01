#!/bin/bash

set_install_env

aptinstallifneed tmux

linkifneed ${S}/tmux.conf ~/.tmux.conf
