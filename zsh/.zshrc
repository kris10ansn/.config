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


# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

source $ZDOTDIR/environment.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/functions.zsh

source /usr/share/fzf/key-bindings.zsh

unsetopt correct_all
unsetopt correct

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/nvm/init-nvm.sh

eval "$(zoxide init zsh)"

# Startup is done — re-enable ctrl+c for the interactive session.
trap - INT
