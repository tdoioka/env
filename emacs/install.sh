#!/bin/bash

# depends cmigemo

source $(realpath `dirname $0`/../lib/libs.sh)

aptinstallifneed emacs

linkifneed ${S}/emacs.d ~/.emacs.d

emacs --script ~/.emacs.d/elpa-byte-compile.el
