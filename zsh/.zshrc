# Ignore ctrl+c while this file is being sourced. A stray SIGINT during startup
# aborts the rest of .zshrc and leaves a half-configured shell (no p10k prompt,
# missing functions). Restored with `trap - INT` at the bottom.
trap '' INT

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment first: manjaro-zsh-prompt reads USE_POWERLINE
source $ZDOTDIR/environment.zsh

# Manjaro zsh configuration and prompt
[[ -e /usr/share/zsh/manjaro-zsh-config ]] && source /usr/share/zsh/manjaro-zsh-config
[[ -e /usr/share/zsh/manjaro-zsh-prompt ]] && source /usr/share/zsh/manjaro-zsh-prompt

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/plugins/ccommit.zsh
[[ -r $ZDOTDIR/local.zsh ]] && source $ZDOTDIR/local.zsh

# Options
unsetopt correct_all
unsetopt correct

# fzf keybindings and completion
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Prompt config lives in the repo; POWERLEVEL9K_CONFIG_FILE makes
# `p10k configure` write back to the same file
export POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/plugins/p10k.zsh"
[[ -r $POWERLEVEL9K_CONFIG_FILE ]] && source $POWERLEVEL9K_CONFIG_FILE

# Lazy-load nvm: init-nvm.sh is slow, so defer it until nvm/node/npm/npx is
# first used. Scripts with a node shebang still work via /usr/bin/node.
if [[ -e /usr/share/nvm/init-nvm.sh ]]; then
  for _cmd in nvm node npm npx; do
    eval "$_cmd() {
      unfunction nvm node npm npx 2>/dev/null
      source /usr/share/nvm/init-nvm.sh
      $_cmd \"\$@\"
    }"
  done
  unset _cmd
fi

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Startup is done — re-enable ctrl+c for the interactive session.
trap - INT
