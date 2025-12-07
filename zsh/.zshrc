# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

reload() { exec zsh; }
mkcd() { mkdir -p "$@" && cd "$@"; }
cdcodium() { cd "$@" && codium "." }
mkcdcodium() { mkcd "$@" && codium "." }
cdclone() { git clone "$@" && cd $(basename "$@" .git) }

git-checkout-unstaged() {
		git stash;
		git checkout "$@"
		git stash pop;
}

export ANDROID_HOME="/opt/android-sdk"
path+="$ANDROID_HOME/tools"
path+="$ANDROID_HOME/platform-tools"
path+="$ANDROID_HOME/cmdline-tools/latest/bin"
path+="$ANDROID_HOME/emulator"

path+="/home/kristian/.local/share/.npm-global/bin/"
path+=$(composer global config bin-dir --absolute --quiet)
path+="$HOME/.local/share/bob/nvim-bin"
path+="$HOME/.dotnet/tools"



# java
export JAVA_HOME=/usr/lib/jvm/default
path+=$JAVA_HOME/bin/bin
# java end

unsetopt correct_all
unsetopt correct

source /usr/share/fzf/key-bindings.zsh

# pnpm
export PNPM_HOME="/home/kristian/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export EDGE_PATH="/usr/bin/brave"
export ZDOTDIR="$HOME/.config/zsh"
export BOB_CONFIG="$HOME/.config/bob/config.json"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/nvm/init-nvm.sh

alias code="codium"
alias cdcode="cdcodium"
alias mkcdcode="mkcdcodium"
alias grep="grep --color=auto"
alias ll="exa -l"
alias ls="ll"
alias v="nvim"
alias c="clear"
alias cdc="cdcode"
alias mkcdc="mkcdcode"
alias l="ls"
alias vz="nvim $ZDOTDIR/.zshrc && reload"
alias vn="nvim $HOME/.config/nvim/init.lua"
alias mk="mkdir"
alias cdtemp="cd $(mktemp -d)"
alias copy="xclip -selection clipboard"

# ip: include --color=always
alias ip="ip --color=always"

# curl: bypass vpn alias
alias curl-novpn="curl --interface wlp1s0"


cmsg() {
		{ git status; echo ""; git diff --cached; } | ollama run deepseek-coder-v2 "
		You are an assistant that writes Git commit messages using the Conventional Commits specification.
		Analyze the following diff and output **only** a commit message in the format:

		<type>(<optional scope>): <short summary>

		Use one of these types: feat, fix, docs, style, refactor, test, chore, perf.
		Keep it under 72 characters. Do not include extra text.

		Status and diff:"
}
