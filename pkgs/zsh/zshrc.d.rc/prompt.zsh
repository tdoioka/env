# add-zsh-hook
# ..............................................................
# To use to easy add zsh hook functions.
# Writing directly prevents the degree of coupling from increasing.
# ................................................................
# Usage:
# add-zsh-hook <HOOK> <FUNC>
# HOOK:
#       zshaddhistory   : When save history commandline
#       preexec         : When before execute command.
#       chpwd           : When changed dir.
#       precmd          : When pre shown prompt.
#       periodic        : When shown prompt, each $PERIOD [sec].
#       zshexit         : When before exit zsh
# FUNCTION:
#       call fanctions.
# see also: <http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Manipulating-Hook-Functions>
autoload -Uz add-zsh-hook

# colors
# ................................................................
# To use to easy color in command line.
autoload -Uz colors

function _pure() {
  GREP_OPTIONS='' LANG=C LC_ALL=C "$@"
}
function _grep() {
  _pure grep "$@"
}
function _sed() {
  _pure sed "$@"
}
function _getipv4() {
  hostname -I |
    _grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' |
    head -c -1
}

function _upfind() {
  target=$1
  parent=$(realpath ${2:-$PWD})

  if [[ -e "${parent}/${target}" ]]; then
    echo "${parent}/${target}"
    return 0
  fi
  if [[ "$parent" == / ]]; then
    return 1
  fi
  _upfind "$target" "${parent}/.."
}
function _repo_manifest_name() {
  manifest="$1/manifest.xml"
  if [[ -L $manifest ]]; then
    readlink $manifest |
      _sed -e 's@^manifests/@@g'
  elif [[ -f $manifest ]]; then
    _grep $manifest -e 'include' |
      _sed -e 's@^[^"]*"\([^"]*\)".*@\1@g'
  fi
}
function _preprompt() {
  _ret=$?
  setopt prompt_subst
  # For line 1 (miscribe)
  local ret date ip tty
  retblnk=${(r:(3-${#_ret})::0:)}

  ret="ret=${retblnk}$_ret | "
  date=$(date +'%y/%m/%d-%H:%M:%S ')
  ip=$(_getipv4 | tr '\n' ' ')' | '
  shlvl="LV:$SHLVL "
  tty=$(tty | _sed -e 's@/dev/@@g')

  _line1="${date}${ret}${ip}${shlvl}${tty} "
  LINE1=
  if [[ "$_ret" -eq 0 ]]; then
    LINE1="${LINE1}%F{008}${date}"
    LINE1="${LINE1}%F{010}${ret}"
    LINE1="${LINE1}%F{154}${ip}"
    LINE1="${LINE1}%F{226}${shlvl}"
    LINE1="${LINE1}%F{226}${tty}"
  else
    LINE1="${LINE1}%F{008}${date}"
    LINE1="${LINE1}%F{196}${ret}"
    LINE1="${LINE1}%F{208}${ip}"
    LINE1="${LINE1}%F{226}${shlvl}"
    LINE1="${LINE1}%F{226}${tty}"
  fi
  # LINE1="$LINE1""%K{016}${(r:($COLUMNS-${#_line1})::.:)}"
  LINE1="$LINE1""${_newline}"

  # For line 3 (current directory coloring)
  nomanaged=
  underrepo=
  undergit=
  # For line 2 (repo info)
  REPOLINE=
  repodir="$(_upfind .repo)"
  if [[ -n "$repodir" ]]; then
    # Get manifest name.
    repo_name="$(_repo_manifest_name "$repodir")"
    # Get branch name.
    repo_branch="$(git -C "$repodir/manifests" rev-parse --abbrev-ref @{u} |
                    _sed -e 's@origin/@@g')"
    # Repo manifest branch tained check.
    repo_tained=
    if test -n "$(git -C "$repodir/manifests" diff --name-only HEAD -- $repo_name)"; then
      repo_tained='*'
    else
      repo_tained=''
    fi
    # Directory info.
    nomanaged=$(dirname $repodir)
    underrepo="${PWD#${nomanaged}}"

    REPOLINE="$REPOLINE%F{002}$repo_branch%f:"
    REPOLINE="$REPOLINE%F{011}$repo_name%f"
    REPOLINE="$REPOLINE%F{001}$repo_tained%f "
  fi

  # For line 2 (vcs info)
  GITLINE=
  gitstatus=$(git status -sb 2>/dev/null)
  if [[ -n "$gitstatus" ]]; then
    # Check branch status
    branch_st=$(echo $gitstatus | head -n 1 |
		  _sed -e 's@## \(No commits yet on \)*@@g')
    branches="${branch_st% \[*}"
    branch=""
    if echo "$branches" | _grep -sq '\.\.\.' ; then
      # Exist tracking branch
      # Set current branch name and tracking branch name.
      branch="${branch}%F{002}${branches%...*}%f..."
      branch="${branch}%F{001}${branches##*...}%f"
      # Check ahead and/or behind.
      ahead="$(echo "${branch_st##*\[}" |
      	       _grep -oe 'ahead \([0-9]*\)' |
               awk '{ print $2}')"
      behind="$(echo "${branch_st##*\[}" |
	        _grep -oe 'behind \([0-9]*\)' |
                awk '{ print $2}')"
      gone="$(echo "${branch_st##*\[}" |
              _grep -oe 'gone')"
      trac=
      [[ -n "$ahead" ]] && trac="${trac}%F{002}+$ahead%f"
      [[ -n "$ahead" && -n "$behind" ]] && trac="${trac},"
      [[ -n "$behind" ]] && trac="${trac}%F{009}-${behind}%f"
      [[ -n "$gone" ]] && trac="%F{009}gone%f"
      [[ -z "$trac" ]] && trac="%F{008}SAME%f"
    else
      branch="%F{002}$branches%f"
      # No tracking branch.
      trac="%F{008}None%f"
    fi
    # Tained check.
    gittop=$(git rev-parse --show-toplevel)
    untracked=$(git ls-files "${gittop}" --exclude-standard --others|wc -l)
    modified=$(git ls-files "${gittop}" --modified|wc -l)
    staged=$(git diff --name-only --cached|wc -l)
    git_work=
    [[ 0 != "$staged" ]] && git_work="${git_work}%F{010}S"
    [[ 0 != "$modified" ]] && git_work="${git_work}%F{009}M"
    [[ 0 != "$untracked" ]] && git_work="${git_work}%F{009}U"
    # Directory info
    # Trim by echo
    [[ -n "$nomanaged" ]] || nomanaged="$gittop"
    undergit="$(echo /$(git rev-parse --show-prefix))"

    GITLINE="$branch [$trac] $git_work%f"
  fi
  VENV_NAME=
  if [[ -n "${VIRTUAL_ENV}" ]]; then
    VENV_NAME="%F{226}{$(basename ${VIRTUAL_ENV})}%f "
  fi
  LINE2=
  if [[ -n "$VENV_NAME$REPOLINE$GITLINE" ]] ;then
    LINE2="$VENV_NAME$REPOLINE$GITLINE${_newline}"
  fi

  # For Line 3
  [[ -n "$nomanaged" ]] || nomanaged="%~"
  underrepo="${underrepo%${undergit%/}}"
  CURRENTDIR=
  CURRENTDIR="${CURRENTDIR}%F{027}${nomanaged/${HOME}/~}"
  CURRENTDIR="${CURRENTDIR}%F{039}${underrepo}"
  CURRENTDIR="${CURRENTDIR}%F{051}${undergit}"

  USRHOST="$(echo -ne "%F{002}%n@%M${_clear}")"
  LINE3="${USRHOST}:${CURRENTDIR}${_newline}"
}

function _venvinfo() {
}

_clear='%s%b%k%f'
_newline='%s%b%k%f'$'\n'

function _pinit() {
  setopt prompt_subst
  PROMPT=
  PROMPT="$PROMPT"'${LINE1}'
  PROMPT="$PROMPT"'${LINE2}'
  PROMPT="$PROMPT"'${LINE3}'
  PROMPT="$PROMPT"'%# '
}
_pinit

add-zsh-hook precmd _preprompt
