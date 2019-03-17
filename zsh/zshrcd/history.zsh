export HISTFILE=$HOME/.zshrc.d/zsh-hist
export HISTSIZE=100000
export SAVEHIST=100000

# Delete duplicate command older.
setopt hist_ignore_all_dups
# Not store the same command as before.
setopt hist_ignore_dups
# Sharing history command shells.
setopt share_history
# Append without creating history file.
setopt append_history
# Append history incrementally.
setopt inc_append_history
# Remove extra blanks when store
setopt hist_reduce_blanks
# Not store beginig with ' ' command
setopt hist_ignore_space
# ignore duplicate command when write to file
setopt hist_save_no_dups
# completion from history
setopt hist_expand
# Not store history command
setopt hist_no_store
# Not store pushd
setopt pushd_ignore_dups

# # To editable after call history.
# setopt hist_verify
# # use zaw commentout
# bindkey "^R" history-incremental-search-backward
# bindkey "^S" history-incremental-search-forward
