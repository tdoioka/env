# autoload colors
# colors

# autoload -Uz vcs_info
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
# zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
# zstyle ':vcs_info:*' actionformats '[%b|%a]'
# function precmd () { vcs_info }
function precmd() {
    gitinfo
    venvinfo
}
function gitinfo() {
    GIT_BR_BRANCH=

    GIT_BR_ST_START=
    GIT_BR_AHEAD=
    GIT_BR_BEHIND=
    GIT_BR_MOD_SEP=
    GIT_BR_GONE=
    GIT_BR_ST_END=

    GIT_BASE=%~
    GIT_SUB=

    # Since `git status` has the same effect,
    # I omit using `git rev-parse` to check if current is in work-dir.
    local gitout=$(git status -bs 2> /dev/null)
    if [[ -n $gitout ]] ; then
	# git branch
	GIT_BR_ST_START="["
	GIT_BR_ST_END="] "
	local branch_st=$(echo $gitout | head -n 1 |
			      sed -e 's@## \(No commits yet on \)*@@g')

	GIT_BR_BRANCH=" ${branch_st% \[*} "

	GIT_BR_AHEAD=$(echo "[${branch_st##*\[}" |
			    grep -oe 'ahead \([0-9]*\)' |
			    sed -e 's@ahead @+@g')
	GIT_BR_BEHIND=$(echo "[${branch_st##*\[}" |
			     grep -oe 'behind \([0-9]*\)' |
			     sed -e 's@behind @-@g')
	if [[ -n "${GIT_BR_AHEAD}" && -n "${GIT_BR_BEHIND}" ]] ; then
	    GIT_BR_MOD_SEP=','
	fi
	if [[ -z "${GIT_BR_AHEAD}" && -z "${GIT_BR_BEHIND}" ]] ; then
	    GIT_BR_GONE=$(echo "$branch_st" |
			      grep -oe "\[gone\]" |
			      sed -e 's@\[gone\]@EMPTY@g')
	    if [[ -z "${GIT_BR_GONE}" ]] ; then
		GIT_BR_GONE='SAME'
	    fi
	fi

	# parse git path spec.
	GIT_BASE=$(git rev-parse --show-toplevel)
	GIT_SUB=$(pwd | sed -e "s@${GIT_BASE}@@g")
	GIT_BASE=$(echo $GIT_BASE | sed "s@${HOME}@~@g")
	if [[ -z "${GIT_SUB}" ]]; then
	    GIT_SUB=" (git-root)"
	fi
    fi
}

function venvinfo() {
    VENV_NAME=
    if [[ -n "${VIRTUAL_ENV}" ]]; then
	VENV_NAME="{$(basename ${VIRTUAL_ENV})} "
    fi
}

function initprmpt() {
    setopt prompt_subst

    local reset_a='%s%b%k%f'
    local Ln="${reset_a}"$'\n'

    ################################################################
    local time_a='%s%b%K{white}%(?,%F{black},%F{red})'
    local time="${time_a} %D/%* "

    local ret_a='%s%b%(?,%K{green}%F{while},%K{red}%F{while})'
    local ret="${ret_a} ret:%? "
    if [[ -n "${SSH_CONNECTION}" ]]; then
	local ssh=" $(echo ${SSH_CONNECTION} | awk '{print $(NF-1)}') "
    fi
    local ssh_a='%s%b%K{yellow}%F{black}'
    ssh="${ssh_a}${ssh}"

    local lv_a='%S%B%K{white}%F{black}'
    local lv="${lv_a} lv:%L "

    local vcsbr_a='%s%B%K{white}%F{black}'
    local vcsbr="${vcsbr_a}"'${GIT_BR_BRANCH}'
    local vcsa_a='%b%F{green}'
    local vcsa="${vcsa_a}"'${GIT_BR_AHEAD}'"${vcsbr_a}"
    local vcssep='${GIT_BR_MOD_SEP}'
    local vcsb_a='%b%F{red}'
    local vcsb="${vcsb_a}"'${GIT_BR_BEHIND}'"${vcsbr_a}"
    local vcsg_a='%B%F{blue}'
    local vcsg="${vcsg_a}"'${GIT_BR_GONE}'"${vcsbr_a}"
    local vcs="${vcsbr}"'${GIT_BR_ST_START}'"${vcsa}${vcssep}${vcsb}${vcsg}"'${GIT_BR_ST_END}'

    ################################################################
    local venv_a='%s%B%K{black}%F{yellow}'
    local venv="${venv_a}"'${VENV_NAME}'

    local host_a='%s%B%K{black}%F{green}'
    local host="${host_a}%n@%M"
    local hdsp="%s%b%k%f:"

    local base_a="%s%B%k%F{blue}"
    local sub_a="%s%B%k%F{cyan}"
    local dir="${base_a}"'${GIT_BASE}'"${sub_a}"'${GIT_SUB}'

    ################################################################
    local count="${count_a}[%h]"
    local put_a='%s%b%f%k'
    local put="${put_a} %% "

    ################################################################
    local top="${time}${ret}${ssh}${lv}${vcs}"
    local mid="${venv}${host}${hdsp}${dir}"
    local tail="${count}${put}"

    PROMPT="${top}${Ln}${mid}${Ln}${tail}"
    RPROMPT=""
}
initprmpt
