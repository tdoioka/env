#!/bin/bash

set -ueo pipefail

function aresame() {
	if [[ -e $2 ]]; then
		local lhs=$(realpath $1)
		local rhs=$(realpath $2)
		if [[ $lhs == $rhs ]]; then
			return 0
		fi
		cmp -s $rhs $lhs || return 1
		return 0
	else
		return 1
	fi
}
