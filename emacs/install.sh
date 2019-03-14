#!/bin/bash

sudo apt install -y emacs

source $(realpath `dirname $0`/../lib/libs.sh)

linkifneed ${S}/emacs.d ~/.emacs.d

emacs --script ~/emacs.d/elpa-byte-compile.el
