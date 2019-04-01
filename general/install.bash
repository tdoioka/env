#!/bin/bash

set_install_env

aptinstallifneed openssh-server
aptinstallifneed net-tools
aptinstallifneed tree
aptinstallifneed nkf
aptinstallifneed build-essential
# for coloring less
aptinstallifneed source-highlight
# for coloring less. install unbuffer.
aptinstallifneed expect

linkifneed "${S}/shrc.d" ~/.shrc.d
