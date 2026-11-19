# Keep PATH free of duplicates across reloads and nested shells
typeset -U path

path+="$HOME/Applications/bin"

# npm global
path+="$HOME/.local/share/.npm-global/bin"

# nvim (managed by bob)
path+="$HOME/.local/share/bob/nvim-bin"
export BOB_CONFIG="$HOME/.config/bob/config.json"

# dotnet
path+="$HOME/.dotnet/tools"

# android
export ANDROID_HOME="$HOME/Android/Sdk"
path+="$ANDROID_HOME/platform-tools"

# java
export JAVA_HOME=/usr/lib/jvm/default
path+="$JAVA_HOME/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
path+="$PNPM_HOME"

# Use the powerlevel10k prompt from manjaro-zsh-prompt
export USE_POWERLINE="true"

export EDITOR="nvim"

# Extend the default ls palette with source, config, and document colors.
export LS_COLORS="${LS_COLORS:+$LS_COLORS:}"\
"*.js=32:*.jsx=32:*.ts=32:*.tsx=32:*.py=32:*.rb=32:*.go=32:*.rs=32:*.cs=32:*.sh=32:*.zsh=32:"\
"*.json=33:*.yaml=33:*.yml=33:*.toml=33:*.xml=33:*.ini=33:*.conf=33:"\
"*.md=36:*.txt=36:*.rst=36"

export MAESTRO_CLI_NO_ANALYTICS=1
