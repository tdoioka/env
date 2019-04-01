#!/bin/bash

set_install_env

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
