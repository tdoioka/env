#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed nkf

function install_cmigemo() {
    rm -rf cmigemo
    git clone https://github.com/koron/cmigemo
    cd cmigemo
    ./configure
    make gcc
    make gcc-dict
    sudo make gcc-install
}

type cmigemo >& /dev/null || {
    (cd "$S" && install_cmigemo)
}
