# Colored / modern defaults
alias ls="eza"
alias ll="eza -la"
alias grep="grep --color=auto"
alias ip="ip --color=always"

# Editors
alias code="codium"
alias v="nvim"

# Edit configs (single quotes: expand $ZDOTDIR/$HOME at use time)
alias vz='nvim $ZDOTDIR && reload'
alias vn='nvim $HOME/.config/nvim/init.lua'
alias vv='nvim $HOME/.config/nvim/'

# Shorthands
alias c="clear"
alias mk="mkdir"
alias cdc="cdcodium"
alias mkcdc="mkcdcodium"

# Clipboard
alias copy="xclip -selection clipboard"

# Misc
alias npms="jq '.scripts' package.json"
alias prettierrc='cp $ZDOTDIR/templates/.prettierrc.json .prettierrc.json'
