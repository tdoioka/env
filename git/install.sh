#!/bin/bash

sudo apt install -y git

source $(realpath `dirname $0`/../lib/libs.sh)

aresame ./gitconfig ~/.gitconfig || {
	ln --backup=t -s $(realpath ./gitconfig) ~/.gitconfig
}
