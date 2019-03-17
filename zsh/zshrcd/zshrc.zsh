function sc() {
    function ee() {
	if [[ -n $TMUX && $SHLVL -le 2 || $SHLVL -eq 1 ]]; then
	    echo "$@"
	fi
    }
    [ -e "$1" ] && {
	ee "zsh: load: $1"
	unfunction ee
	source "$1"
    } || {
	ee "zsh: skip: **** $1"
	unfunction ee
    }
}
sc ~/.zshrc.d/proxy.zsh
sc ~/.zshrc.d/sub/zawrc.zsh
sc ~/.zshrc.d/sub/zaw.zsh
sc ~/.zshrc.d/prompt.zsh
sc ~/.zshrc.d/history.zsh
sc ~/.zshrc.d/general.zsh
sc ~/.zshrc.d/git.zsh
sc ~/.zshrc.d/emacs.zsh
sc ~/.zshrc.d/kermit.zsh
