#!/bin/bash -e

function ftype() {
    [[ "$(type -t $1 2> /dev/null)" == "function" ]]
}
ftype _base_init || {
    function _base_init() {
	set -ueo pipefail
	# require path
	export REQUIRE_PATH="$(realpath `dirname ${BASH_SOURCE}`)"
	# required list
	declare -xa REQUIRED
    }
    # print script name
    function require() {
	[[ $# -ne 0 ]] || return 1
	if [[ ! " ${REQUIRED[@]} " =~ " $1 " ]]
	then
	    source "${REQUIRE_PATH}/$1.sh"
	    REQUIRED=("${REQUIRED[@]}" "$1")
	fi
    }
    # echo to error
    function err() {
	echo "$@" 1>&2
    }
    _base_init
}
