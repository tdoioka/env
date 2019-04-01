#!/bin/bash

# usage: source "$(realpath `dirname $0`/../lib/libs.sh)"

type setparam >& /dev/null && {
    setparam 2
} || {
    # Run only once in one shell

    if [[ "$_" == "$0" ]]; then
	set -ueo pipefail
    fi

    # require sudo password for isntall
    sudo ls >& /dev/null

    function setparam() {
	# $1 source backtrace number
	S="$(realpath `dirname ${BASH_SOURCE[${1:-1}]}`)"
	M="${S##*/}"
	B="${S}/build"
	R="$(realpath $S/..)"
	# echo $M, $R, $S, $B
	# echo "setparam: $M (${BASH_SOURCE[@]})"
    }

    setparam 2
    export REQUIRED=("$M")

    # install.sh in other directory.
    # $1 is directory name.
    function require() {
	[[ $# -ne 0 ]] || return 1
	if [[ -z $(echo "${REQUIRED[@]}" | grep -e "$1") ]];
	then
	    export REQUIRED=("${REQUIRED[@]}" "$1")
	    # echo "REQUIRED:${REQUIRED[@]}"
	    source "$R/$1/install.sh"
	    setparam 2
	fi
    }

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
    function gitclone() {
	if [[ ! -d "${B}/.git" ]]; then
	    rm -rf "${B}/.git"
	    git clone "$1" "${B}"
	fi
    }

    # wget tarball from $1 to ${S}/dl, and extract then
    # create an ${S}/build symbolic link to extracted dir.
    function gettarball() {
	local tarname="${1##*/}"
	local name="${tarname%.t*}"
	local dl="${S}/dl"

	mkdir -p "${dl}"

	[[ -e "${dl}/${tarname}" ]] || {
	    wget "$1" -O "${dl}/${tarname}"
	}
	[[ -d "${dl}/${name}" ]] || {
	    tar xf "${dl}/${tarname}" -C "${dl}"
	}
	ln -nsf "${dl}/${name}" "${B}"
    }
}
