#!/bin/bash

set -ueo pipefail

# usage: source "$(realpath `dirname $0`/../lib/libs.sh)"

# S: script current directory
S="$(realpath `dirname $0`)"

# compaire $1 and $2, same or not.
function aresame() {
	if [[ -e "$2" ]]; then
		local lhs="$(realpath $1)"
		local rhs="$(realpath $2)"
		# same object
		if [[ "$lhs" == "$rhs" ]]; then
			return 0
		fi
		# same contents
		cmp -s "$rhs" "$lhs" || return 1
		return 0
	else
		return 1
	fi
}

# make symboliclink $2 to $1.
# if $2 is not exist, just make symboliclink.
# if $2 and $1 are not same, backup old $1 and make symboliclink.
# if $2 and $1 are same, do nothing.
function linkifneed() {
    aresame "$1" "$2" || {
	backupdir "$2"
	ln -v --backup=t -nfs "$1" "$2"
    }
}

# backup dirctory $1 with BACKUPOPTION
BACKUPDIR_OPT="t"
function backupdir() {
    if [[ -d "$1" ]]; then
	local name="${1##*/}"
	local dir="$(dirname $1)"
	mkdir /tmp/$name
	mv -v --backup="${BACKUPDIR_OPT}" "/tmp/$name" "$dir"
	rmdir "$1"
    fi
}

# when $1 is installed by apt returns true
function isaptinstalled() {
    dpkg -l | awk '{print $2}' | sed 1,5d | grep -w "^$1$" >& /dev/null
}
# install $1 if not installed
function aptinstallifneed() {
    isaptinstalled "$1" || {
	sudo apt install -y "$1"
    }
}

# git clone $1 to ${S}/git dir
function git_clone() {
    if [[ ! -d "${S}/git/.git" ]]; then
	rm -rf "${S}/git/.git"
	git clone "$1" ${S}/git
    fi
}
