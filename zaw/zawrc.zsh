#
# settings zaw for me.
#

# http://qiita.com/termoshtt/items/68a5372a43543037667f

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
# Number of storing cdr history.
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

# zstyle ':filter-select:highlight' selected fg=black,bg=white,standout
zstyle ':filter-select' case-insensitive yes

bindkey '^@' zaw-cdr
bindkey '^R' zaw-history
bindkey '^X^F' zaw-git-files
bindkey '^X^B' zaw-git-branches
bindkey '^X^P' zaw-process
# bindkey '^A' zaw-tmux
