#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed nkf

gitclone "https://github.com/koron/cmigemo"

type cmigemo >& /dev/null || {
    ({
	cd "$B"
	./configure
	make gcc
	make gcc-dict
	sudo make gcc-install
    })
}
