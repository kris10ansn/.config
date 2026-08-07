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
