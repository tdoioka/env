#!/bin/bash

set_install_env

install_depend python
pip install Pygments

aptinstallifneed exuberant-ctags

aptinstallifneed libncurses5-dev

gettarball "http://tamacom.com/global/global-6.6.3.tar.gz"
type global >& /dev/null || {
    ({
	cd "$B"
	./configure
	make
	sudo make install
    })
}

linkifneed ${S}/gtags.conf ~/.globalrc
