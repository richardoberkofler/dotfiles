#!/bin/bash

set -euo pipefail

# Customize this with your GitHub URL
DOTFILES_REPO="git@github.com:richardoberkofler/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles/"

NO_PULL=false
for arg in "$@"; do
  if [ "$arg" == "--no-pull" ]; then
    NO_PULL=true
  fi
done

if [ "$NO_PULL" = true ]; then
  echo "[*] Skipping clone/pull"
elif [ -z "${CI:-}" ]; then
  echo "[*] Cloning dotfiles..."
  if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    mkdir -p "$DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  elif [ "$NO_PULL" = false ]; then
    echo "Updating dotfiles..."
    git -C "$DOTFILES_DIR" pull
  fi
else
  echo "[*] CI detected, skipping clone/pull."
fi

cd "$DOTFILES_DIR"

source setup/common.sh

# OS-specific setup
if [ -f /etc/arch-release ]; then
  source setup/arch.sh
elif [ -f /etc/debian_version ]; then
  source setup/ubuntu.sh
elif [ "$(uname)" == "Darwin" ]; then
  source setup/macos.sh
fi

echo "[*] Stowing dotfiles ..."

stow */

echo "✅ Done. Restart your terminal or run: `exec zsh`"
