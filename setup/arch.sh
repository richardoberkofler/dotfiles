#! /bin/bash

echo "[*] Running Arch Linux setup..."

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

sudo pacman -Syu --noconfirm git zsh tmux curl unzip base-devel fzf eza lazygit starship zoxide neovim htop ripgrep atuin

if ! command -v yay &>/dev/null; then
  echo "Installing yay (AUR helper)..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
fi

if ! command -v nix &>/dev/null; then
  echo "Installing nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
fi

if grep -qEi "(Microsoft|WSL)" /proc/version >/dev/null 2>&1; then
    export DISPLAY=:0
fi
