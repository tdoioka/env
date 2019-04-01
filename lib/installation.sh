#!/bin/bash -e

require path

sudo ls >& /dev/null

# install script name
declare -gx INS_FNAME='install.bash'
# install root.
declare -gx R=''
# install script list
declare -gxa INSTALL_ITEMS=()
# backup option for backupdir, linkifneed.
declare -gx BACKUPOPT='t'
# List of depends items
declare -gxa DEPENDS=()

#
# Usage: init_install_env [DIR]
#
#   Install environment setting.
#   Set ${R}, which is the installation root dir.
#   Set ${INSTALL_ITEMS}, which is install script list.
#   if DIR arg not set, ${R} is set caller currrent script dir.
#
function init_install_env() {
    if [[ -z "${R}" ]]; then
	R=${1:-$(current_dir 2)}
	INSTALL_ITEMS=($(find "${R}" -type f -name "$INS_FNAME" |
			      sed -e "s@${R}/@@g" \
				  -e "s@/*${INS_FNAME}@@g"))
	set_install_env 3
    fi
}

#
# Usage: set_install_env [BACKTRACE_NO]
#
#   Set ${S} which is INSTALL_ITEM root dir.
#   Set ${B} which is INSTALL_ITEM build dir.
#
function set_install_env() {
    # echo "${1:-2} -- ${BASH_SOURCE[@]}"
    S="$(current_dir ${1:-2})"
    B="${S}/build"
}

#
# Usage: depend INSTALL_ITEM
#
#   Run install script of INSTALL_ITEM
#
function install_depend() {
    [[ $# -ne 0 ]] || return -1
    [[ " ${INSTALL_ITEMS[@]} " =~ " $1 " ]] || return -1
    if [[ ! " ${DEPENDS[@]} " =~ " $1 " ]]; then
	DEPENDS+=("${1}")
	S="${R}/${1}"
	B="${S}/build"
	source "${R}/${1}/${INS_FNAME}"
	set_install_env 3
    fi
}

#
# Usage: aptinstallifneed PACAKGE
#
#   apt install PACKAGE when PACKAGE is not installed
#
function aptinstallifneed() {
    [[ $# -ne 0 ]] || return -1
    dpkg -l | awk '{print $2}' | sed 1,5d |
	grep -w "^$1\(:.*\)*$" >& /dev/null || {
	sudo apt install -y "$1"
    }
}

#
# Usage: aresame LHS RHS
#
#   compaire LHS and RHS, same or not.
#
function aresame() {
    [[ $# -ge 2 ]] || return -1
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

#
# Usage: backupdir DIR
#
#   rename DIR for backup.
#   backupd name decide by mv command..
#
function backupdir() {
    [[ $# -ne 0 ]] || return -1
    if [[ -d "$1" ]]; then
	local name="${1##*/}"
	local dir="$(dirname $1)"
	mkdir /tmp/$name
	mv -v --backup="${BACKUPOPT}" "/tmp/$name" "$dir"
	rmdir "$1"
    fi
}

#
# Usage: linkifneed SRC DST
#
#   make symboliclink DST to SRC.
#   Unlike cp and ln, DST can not omit file names.
#
#   if DST is not exist, just make symboliclink.
#   if SRC and DST are not same, backup DST and make symboliclink.
#   if SRC and DST are same, do nothing.
#
function linkifneed() {
    [[ $# -ge 2 ]] || return -1
    aresame "$1" "$2" || {
	backupdir "$2"
	ln -v --backup="${BACKUPOPT}" -nfs "$1" "$2"
    }
}

#
# Usage: gitclone URL
#
#   git clone URL to ${B} dir
#   If it is already cloned, this command skip.
#
function gitclone() {
    [[ $# -ne 0 ]] || return -1
    if [[ ! -d "${B}/.git" ]]; then
	rm -rf "${B}/.git"
	git clone "$1" "${B}"
    fi
}

#
# Usage: gettarball URL
#
#   wget tarball from URL to ${S}/dl, and extract then
#   create a ${S}/build symbolic link to extracted dir.
#
function gettarball() {
    [[ $# -ne 0 ]] || return -1
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
