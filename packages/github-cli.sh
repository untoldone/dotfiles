#!/usr/bin/env bash

set -e

if [[ $(which gh) ]]; then
  echo "GitHub CLI already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Add GitHub CLI repository
    if [[ ! -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]]; then
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/github-cli.list ]]; then
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update
    fi

    sudo apt-get install -y gh
    ;;
  darwin)
    brew install gh
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
