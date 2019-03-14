#!/bin/bash

source $(realpath `dirname $0`/../lib/libs.sh)

aptinstallifneed git

linkifneed ${S}/gitconfig ~/.gitconfig
