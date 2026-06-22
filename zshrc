SCRIPT_DIR="${0:A:h}"

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
# Left empty so the self-contained prompt below runs instead of an OMZ theme
ZSH_THEME=""
plugins=(git rust)

# git completion (fpath must be set before oh-my-zsh.sh runs compinit)
fpath=($SCRIPT_DIR/completions $fpath)

# Large in-memory + on-disk history on a persistent volume. Set before sourcing
# OMZ so its lib/history.zsh floors don't lower these. OMZ only ever raises them.
HISTFILE=/workspaces/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Config
export SHELL=zsh
export EDITOR="code --wait"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GPG_TTY=$(tty)

source $ZSH/oh-my-zsh.sh

# Home/End fallbacks: OMZ only binds these via terminfo, but the VS Code
# integrated terminal and tmux send raw ^[[H / ^[[F (and ^[[1~ / ^[[4~), which
# OMZ leaves unbound — fill that gap.
bindkey "^[[H" beginning-of-line; bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line;       bindkey "^[[4~" end-of-line

# zsh syntax highlighting (sourced last, after OMZ defines its ZLE widgets)
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
