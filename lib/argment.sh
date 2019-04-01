#!/bin/bash -e
require base

# Parse result of argument list array
declare -gxa ARGS=()

#
# Ussage: usage_exit [RETCODE]
#
# Show help and exit the shell.
#
# RETCODE:
#   Exit code. Set to 1 if empty.
#
function usage_exit() {
    # show description
    function show_description() {
	if [[ -n "${HELP_DESCRIPTION[@]}" ]]; then
	    err ''
	fi
	for line in "${HELP_DESCRIPTION[@]}"; do
	    cat <<_EOS_ 1>&2
        ${line}
_EOS_
	done
    }
    # show option help string
    function show_option_help() {
	if [[ -n "${OPTDICT[@]}" ]]; then
	    cat <<_EOS_ 1>&2

    OPTIONS:
_EOS_
	fi
	for line in "${OPTDICT[@]}"; do
	    cat <<_EOS_ 1>&2
        ${line%% -- *} :
	    ${line#* -- }
_EOS_
	done
    }

    # usage exit main
    local ret=${1:-1}
    cat <<_EOS_ 1>&2

    Usage: ${PROGNAME} ${ARGUMENT_STR}
_EOS_
    show_description
    show_option_help
    exit $ret
}

#
# Usage: add_cmd_description DESCRIPTION
#
#   Add one line of description.
#
function add_cmd_description() {
    HELP_DESCRIPTION+=("$*")
}

#
# Usage: set_argument_string DESCRIPTION
#
function set_argument_string() {
    ARGUMENT_STR="${*}"
}

#
# Ussage: setopt ID[:-] OPTION_STR -- HELPMESSAGE
#
#   Set option spec string for argument parser
#
# ID:
#   Identifier for option. This name must be unique.
#   ID is define by the following regular expression:
#
#	[a-zA-Z0-9_][a-zA-Z0-9_]*[:-]*
#
#     - If the name ends with `:', This option requires a parameter.
#     - If the name ends with `-', This long option can set a parameter.
#	(In the case of short option, paramatercan not be set.)
#
#   ID is an internal definition, usually not displayed to the user.
#
# OPTION_STR:
#   Specify option string of ID.
#   This string is also used for help message.
#
#   During parseargs(), replace all but the following characters with blanks
#   and ignore strings not beginning with `-'.
#     - Alphabet, numbers, underscores, hyphens. (same as [a-zA-Z0-9_-]).
#
# HELPMESSAGE:
#   This string is help message this option
#
# usage example
#   eg1. define the -1 option which not have parameter.
#     setopt option -1 -- help message
#   eg2. define the -2 and --option2 which can be set parameter.
#     setopt option2- -2 --option2[=PARAM] -- help message
#   eg3. define the -2 and --option2 which require parameter.
#     setopt option3: -3 PARAM --option3=PARAM -- help message
#
function setopt() {
    local id blacklist
    # check argument count
    [[ $# -ge 3 ]] || {
	err "setopt: id is need argument"
	return 1
    }
    # check ID
    [[ $1 =~ [a-zA-Z0-9_][a-zA-Z0-9_]*[:-]* ]] || {
	err "setopt: i"
	return 1
    }
    case $1 in
	*:)
	    id="${1%%:}"
	    blacklist=("${OOPTLIST[@]}" "${SOPTLIST[@]}")
	    ;;
	*-)
	    id="${1%%-}"
	    blacklist=("${VOPTLIST[@]}" "${SOPTLIST[@]}")
	    ;;
	* )
	    id="${1}"
	    blacklist=("${VOPTLIST[@]}" "${OOPTLIST[@]}")
	    ;;
    esac
    if [[ " ${BLACKLIST[@]} " =~ "${id}" ]]; then
       err "option setting error. ${id} is already registered."
       return 1
    fi

    # check option duplicate.
    local opt
    for opt in "$@"; do
	case $opt in
	    -- ) break ;;
	    -* )
		opt="$(echo $opt | sed -e 's#[^a-zA-Z0-9_-].*$##g')"
		if [[ " ${!OPTSTRS[@]} " =~ " ${opt} " ]]; then
		    local old="${OPTSTRS[${opt}]}"
		    if [[ "${old}" != "${id}" ]]; then
			# exist stirng
			err "'${opt}' option duplicate in ${id}. Already set by ${old}."
			return 1
		    fi
		fi
		# Register option string
		OPTSTRS["${opt}"]="${id}"
		;;
	esac
    done

    # Register option identify
    case $1 in
	*:) VOPTLIST+=("${id}") ;;
	*-) OOPTLIST+=("${id}") ;;
	* ) SOPTLIST+=("${id}") ;;
    esac
    # Register
    shift
    OPTDICT["${id}"]="${*}"
}

#
# Usage: parseargs $@
#
#   Parse argument, and set inner parameter list of ARGS() and dict of OPTS().
#
function parseargs() {
    # reset argumets and options
    ARGS=()
    OPTS=()

    # found id by option string
    function echo_id() {
	local arg="${1%%=*}"
	if [[ " ${!OPTSTRS[@]} " =~ "${arg}" ]]; then
	    echo "${OPTSTRS[${arg}]}"
	else
	    err "notfound option $arg"
	    usage_exit
	fi
    }

    # parse all arguments
    while (( $# > 0 )); do
	case "$1" in
	    -- )
		# Finish parse. Put all remaining args into ARGS.
		shift
		ARGS+=("$@")
		break ;;
	    --* )
		# Parse long option.
		local id=$(echo_id "$1")
		[[ -n "$id" ]] || exit 1 # it is unregistered option

		local optarg=""
		if [[ " ${VOPTLIST[@]} " =~ " ${id} " ]]; then
		    # the option requires parameter
		    if [[ "$1" =~ = ]]; then
			optarg="${1#*=}"
		    else
			err "need an argument $1 option ($id)"
			return 1
		    fi
		elif [[ " ${OOPTLIST[@]} " =~ " ${id} " ]]; then
		    # the option can have parameter
		    if [[ "$1" =~ = ]]; then
			optarg="${1#*=}"
		    fi
		elif [[ " ${SOPTLIST[@]} " =~ " ${id} " ]]; then
		    # the option do not have parameter
		    if [[ "$1" =~ = ]]; then
			err "no need argument $1 option ($id)"
			return 1
		    fi
		fi
		OPTS["${id}"]="${optarg}"
		shift ;;
	    -*  )
		# Parse short option.
		local id=$(echo_id "$1")
		[[ -n "$id" ]] || exit 1 # it is unregistered option

		local optarg=""
		if [[ " ${VOPTLIST[@]} " =~ " ${id} " ]];then
		    # the option requires parameter
		    if [[ $# -lt 2 || "$2" =~ ^-.* ]]; then
			# error when next arg is option or nothing.
			err "$1 option is need argument"
		    fi
		    optarg="$2"
		    shift
		fi
		OPTS["${id}"]="${optarg}"
		shift ;;
	    *   )
		# Since it is a non option arg, put it in ARGS.
		ARGS+=("$1")
		shift ;;
	esac
    done
}

#
# getopt ID
#
#   Whether opt ID is set.
#
function getopt() {
    [[ " ${!OPTS[@]} " =~ " ${1} " ]]
}

#
# getoptarg ID
#
#   Get the value of opt ID.
#
function getoptarg() {
    if [[ " ${!OPTS[@]} " =~ " ${1} " ]]; then
	echo "${OPTS[$1]}"
	return 0
    fi
    return 1
}

#
# Usage: init_argument_parser
#
#   Initalize argument parser parameter
#   It is read automatically so users don't usually need to use it.
#
function init_argument_parser() {
    ARGS=()
    # ................................................................
    # for internal use variable
    # ................................................................
    # shell name
    PROGNAME=$(basename $0)
    # shell argument
    ARGUMENT_STR=
    # Command description message.
    declare -gxa HELP_DESCRIPTION
    # Option identify list which requires parameter.
    declare -gxa VOPTLIST=()
    # Option identify list which can have parameter.
    declare -gxa OOPTLIST=()
    # Option identify list which do not have parameter.
    declare -gxa SOPTLIST=()
    # Dict for check duplicate option strings.
    # key   : option string
    # value : An opton identify
    declare -gxA OPTSTRS=()
    # The dict of option list.
    # key   : An option identify
    # value : A string shich spec and help message separated by '--'
    declare -gxA OPTDICT=()
    # The dict of Pase result of Options
    # key   : an option identify
    # value : option paramater
    declare -gxA OPTS=()
    # ................................................................
}

#
# Automatic setting
# Initializing module and set help options.
#
init_argument_parser
setopt help -h --help -- Show this help message
