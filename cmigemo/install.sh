#!/bin/bash

source "$(realpath `dirname $0`/../lib/libs.sh)"

aptinstallifneed nkf

git_clone "https://github.com/koron/cmigemo"

type cmigemo >& /dev/null || {
    ({
	cd "$S"/git
	./configure
	make gcc
	make gcc-dict
	sudo make gcc-install
    })
}
