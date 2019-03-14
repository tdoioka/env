#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

bash "${S}/../cmigemo/install.sh"

aptinstallifneed emacs

linkifneed "${S}/emacs.d" ~/.emacs.d

emacs --script ~/.emacs.d/elpa-byte-compile.el
