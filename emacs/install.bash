#!/bin/bash

set_install_env

install_depend cmigemo

aptinstallifneed emacs

linkifneed "${S}/emacs.d" ~/.emacs.d

emacs --script ~/.emacs.d/elpa-byte-compile.el
