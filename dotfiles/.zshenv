#### .env? yes ---- ;)
### the env zsh gonna read
### it's not symlinked
### do `source ~/.zshenv` after changes or reopen the terminal

export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/36.0.0/
export PATH=$PATH:$ANDROID_HOME/emulator