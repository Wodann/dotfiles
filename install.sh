#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install dependencies
sudo apt update
sudo apt install -y zsh-syntax-highlighting

# Source this repo's zshrc from ~/.zshrc (idempotent: avoids duplicate lines on re-run)
zshrc_source="source $SCRIPT_DIR/zshrc"
if ! grep -qxF "$zshrc_source" "$HOME/.zshrc" 2>/dev/null; then
  echo "$zshrc_source" >> "$HOME/.zshrc"
fi

# Use the tracked git config via an include rather than symlinking ~/.gitconfig.
# A symlink lets the dev container's per-session git credential helper write
# back into this repo; an include keeps ~/.gitconfig writable and untracked.
git config --global include.path "$SCRIPT_DIR/git/gitconfig"

# Install Claude Code if it isn't already available
if ! command -v claude &> /dev/null; then
  "$SCRIPT_DIR/install-claude.sh"
fi
