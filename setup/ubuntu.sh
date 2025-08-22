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
sudo apt-get install -y git zsh tmux curl unzip build-essential fzf eza zoxide neovim htop ripgrep neofetch stow cloc

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo ./lazygit/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf ./lazygit/lazygit.tar.gz -C ./lazygit
sudo install ./lazygit/lazygit -D -t /usr/local/bin/
rm ./lazygit/lazygit.tar.gz ./lazygit/lazygit ./lazygit/LICENSE ./lazygit/README.md

# Install starship
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if ! command -v atuin &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

if grep -qEi "(Microsoft|WSL)" /proc/version >/dev/null 2>&1; then
    export DISPLAY=:0
fi
