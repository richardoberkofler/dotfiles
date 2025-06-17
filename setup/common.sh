#! /bin/bash

echo "[*] Installing common CLI tools..."

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "[*] Setting ZSH as default shell..."

CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
ZSH_PATH=$(command -v zsh)

if [ "$(basename "$CURRENT_SHELL")" = "zsh" ]; then
    echo "zsh is already the default shell. No changes made."
    exit 0
fi

if [ -n "$ZSH_PATH" ] && grep -Fxq "$ZSH_PATH" /etc/shells; then
    chsh -s "$ZSH_PATH"
else
    echo "Valid zsh path not found in /etc/shells. Falling back to default known path..."
    if grep -Fxq "/usr/bin/zsh" /etc/shells; then
        chsh -s /usr/bin/zsh
    elif grep -Fxq "/bin/zsh" /etc/shells; then
        chsh -s /bin/zsh
    else
        echo "No valid zsh path found in /etc/shells. Aborting."
        exit 1
    fi
fi
