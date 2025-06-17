#! /bin/bash

echo "[*] Installing common CLI tools..."

if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
