SCRIPT_DIR="${0:A:h}"

plugins=(git rust)

# git completion
fpath=($SCRIPT_DIR/completions $fpath)

# Increase history size and save it in a volume for persistence
HISTFILE=/workspaces/zsh_history
HISTSIZE=1000000

# Config
export SHELL=zsh
export EDITOR="code --wait"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GPG_TTY=$(tty)

# zsh syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh