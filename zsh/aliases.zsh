alias ls="ls --color=auto --human-readable --group-directories-first"
alias ll="ls -l"
# Colored / modern defaults
alias grep="grep --color=auto"
alias ip="ip --color=always"

# Editors
alias code="codium"
alias v="nvim"

# Edit configs (single quotes: expand $ZDOTDIR/$HOME at use time)
alias cz='cd $ZDOTDIR'
alias vz='nvim $ZDOTDIR && reload'
alias vn='nvim $HOME/.config/nvim/init.lua'
alias vv='nvim $HOME/.config/nvim/'

# Shorthands
alias mk="mkdir"
alias c="codium ."
alias cdc="cdcodium"
alias mkcdc="mkcdcodium"

# Clipboard
alias copy="xclip -selection clipboard"

# Misc
alias npms="jq '.scripts' package.json"
alias prettierrc='cp $ZDOTDIR/templates/.prettierrc.json .prettierrc.json'

alias clear='printf "\033[2J\033[H"'
