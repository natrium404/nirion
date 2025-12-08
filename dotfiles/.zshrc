# Set PATH
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"

# Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  fzf
  extract
  asdf
  history-substring-search
  zsh-autosuggestions
  fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Disable unnecessary features
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
DISABLE_AUTO_UPDATE="true"

# Enable features
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Starship prompt setup
eval "$(starship init zsh)"
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡"
SPACESHIP_PROMPT_ORDER=(
    time
    user
    dir
    git
    line_sep
    char
)

# ASDF setup
[ -s "${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/" ] && . ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

# fzf keybindings
eval "$(fzf --zsh)"

# Custom completions
fpath=("/home/natrium/.zsh/completions" $fpath)

# History settings
export HISTCONTROL=ignoreboth
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Man page formatting
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

# Command-not-found handler
source /usr/share/doc/pkgfile/command-not-found.zsh

# Alias file
source ~/.zshalias
