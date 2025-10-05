#!/usr/bin/env bash

set -e

# Check if FNM is already installed by looking for installation directory
if [[ -d ~/.local/share/fnm ]] || [[ -d ~/.fnm ]]; then
  echo "FNM already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    ;;
  darwin)
    brew install fnm
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac

# Add FNM to PATH and zshrc if not already present
if ! grep -q "fnm" ~/.zshrc 2>/dev/null; then
  echo 'export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"' >> ~/.zshrc
  echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc
fi

# Load FNM for current session
export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# Install latest LTS Node.js
fnm install --lts
fnm default lts-latest