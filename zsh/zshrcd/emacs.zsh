# initalize
function init_emacsdaemon () {
    local count=$(($(ps -ax | grep 'emacs --daemon' 2>/dev/null | wc -l)-1))
    if [[ $count -eq 0 ]] ;then
	echo "START:emacs daemon"
	emacs --daemon
    fi
}
# finalize
function kill_emacs() {
    if [[ $# -eq 0 ]]; then
	echo "KILL:emacs daemon"
	emacsclient -e '(kill-emacs)'
	return
    fi
    if [[ $1 = '-f' ]]; then
	echo "KILL -f :emacs daemon"
	emacsclient -e '(progn (defun yes-or-no-p (p) t) (kill-emacs))'
    fi
}

# zsh: emacs like keybind
bindkey -e
# start up emacs daemon
init_emacsdaemon
# set alias to emacs client
alias e='emacsclient -nw'
# default editor
EDITOR='emacsclient -nw'
# lunch up editor (if able)