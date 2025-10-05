#!/usr/bin/env bash

set -e

if [[ $(which claude) ]]; then
  echo "Claude Code already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install Claude Code CLI via npm (requires Node.js/fnm to be installed first)
    if ! command -v npm &> /dev/null; then
      echo "Warning: npm not found. Skipping Claude Code installation."
      echo "Run this script again after restarting your shell to install Claude Code."
      exit 0
    fi
    npm install -g @anthropic-ai/claude-code
    ;;
  darwin)
    # Install Claude Code CLI for macOS
    if command -v brew &> /dev/null; then
      brew install --cask claude-code
    else
      echo "Warning: Homebrew not found. Skipping Claude Code installation."
      exit 0
    fi
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
