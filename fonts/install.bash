#!/bin/bash

set_install_env

linkifneed ${S}/fonts ~/.fonts

gitclone https://github.com/edihbrandon/RictyDiminished ricty
for file in $(find ${B}/ricty -maxdepth 1 -type f); do
    linkifneed "${file}" ~/.fonts/$(basename "${file}")
done
