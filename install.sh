#!/bin/bash

# load libs
source "$(realpath `dirname $0`/lib/base.sh)"

# set up argument functions
require argment
setopt all --all, -a -- Run all install script.
parseargs "$@"

# set up install functions
require installation
set_argument_string INSTALL_SCRIPT [INSTALL_SCRIPT...]
init_install_env

# if all flag set then run all install scripts.
$(getopt all) && {
    ARGS=("${INSTALL_ITEMS[@]}")
}
# empty check
[[ "${#ARGS[@]}" -ne 0 ]] || usage_exit

# run install script roop
for ii in "${ARGS[@]}"
do
    install_depend $ii
done
