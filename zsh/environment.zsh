# npm global
path+="$HOME/.local/share/.npm-global/bin/"

# nvim
path+="$HOME/.local/share/bob/nvim-bin"

# dotnet
path+="$HOME/.dotnet/tools"

# android
export ANDROID_HOME="/opt/android-sdk"
path+="$ANDROID_HOME/tools"
path+="$ANDROID_HOME/platform-tools"
path+="$ANDROID_HOME/cmdline-tools/latest/bin"
path+="$ANDROID_HOME/emulator"
# android end

# java
export JAVA_HOME=/usr/lib/jvm/default
path+=$JAVA_HOME/bin/bin
# java end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
path+="$PNPM_HOME"
# pnpm end

export EDGE_PATH="/usr/bin/brave"
export ZDOTDIR="$HOME/.config/zsh"
export BOB_CONFIG="$HOME/.config/bob/config.json"

# Use powerline
export USE_POWERLINE="true"