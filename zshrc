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

# Self-contained port of the `devcontainers` Oh My Zsh theme
#
# Guard: if a theme is already managing the prompt (e.g. Oh My Zsh set
# ZSH_THEME), leave it alone and don't override.
if [[ -z "$ZSH_THEME" ]]; then
  autoload -U colors && colors
  setopt prompt_subst

  __git_prompt() {
    local branch
    branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
      || git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      echo -n "%{$fg_bold[cyan]%}(%{$fg_bold[red]%}${branch}%{$fg_bold[cyan]%})%{$reset_color%} "
    fi
  }

  local prompt_username
  if [[ -n "$GITHUB_USER" ]]; then
    prompt_username="@${GITHUB_USER}"
  else
    prompt_username="%n"
  fi
  PROMPT="%{$fg[green]%}${prompt_username} %(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )" # user + exit-code arrow
  PROMPT+='%{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%} '                      # cwd
  PROMPT+='$(__git_prompt)'                                                              # git branch
  PROMPT+='%{$fg[white]%}$ %{$reset_color%}'
fi
