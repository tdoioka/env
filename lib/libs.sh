#!/bin/bash

set -ueo pipefail

# usage: source $(realpath `dirname $0`/../lib/libs.sh)

# S: script current directory
S="$(realpath `dirname $0`)"

# compaire $1 and $2, same or not.
function aresame() {
	if [[ -e $2 ]]; then
		local lhs=$(realpath $1)
		local rhs=$(realpath $2)
		# same object
		if [[ $lhs == $rhs ]]; then
			return 0
		fi
		# same contents
		cmp -s $rhs $lhs || return 1
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
    aresame $1 $2 || {
	ln --backup=t -s $1 $2
    }
}
