#! /bin/bash

echo "[*] Running Ubuntu setup..."

if [ -n "${CI:-}" ]; then
  sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
  sudo locale-gen
  echo "CI detected, skipping localectl set-locale."
else
  sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
  sudo sed -i '/^#de_AT.UTF-8 UTF-8/s/^#//' /etc/locale.gen
  sudo locale-gen
  sudo localectl set-locale LANG=de_AT.UTF-8
fi

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git zsh tmux curl unzip build-essential fzf eza zoxide neovim htop ripgrep neofetch

# Install starship
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if grep -qEi "(Microsoft|WSL)" /proc/version >/dev/null 2>&1; then
    export DISPLAY=:0
fi
