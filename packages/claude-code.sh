#!/usr/bin/env bash

set -e

if [[ $(which claude-code) ]]; then
  echo "Claude Code already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install Claude Code CLI for Debian/Ubuntu
    curl -fsSL https://anthropic.com/claude-code/install.sh | bash
    ;;
  darwin)
    # Install Claude Code CLI for macOS
    brew install --cask claude-code
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac
