#!/bin/bash

sudo apt install -y git

source $(realpath `dirname $0`/../lib/libs.sh)

linkifneed ${S}/gitconfig ~/.gitconfig
