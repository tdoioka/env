#!/bin/bash

[[ -f /tmp/id_rsa.pub ]] || exit

git clone git://github.com/sitaramc/gitolite
mkdir -p ~/bin
gitolite/install -to ~/bin
~/bin/gitolite setup -pk /tmp/id_rsa.pub

