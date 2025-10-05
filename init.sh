#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(dirname $0)"

cd $SCRIPT_PATH

# Ask for the administrator password upfront (if not already authenticated)
# Skip if running in non-interactive mode (like CI/testing)
if [ -t 0 ]; then
  sudo -v
  # Keep-alive: update existing `sudo` time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
else
  # Non-interactive: just verify sudo works
  sudo -n true 2>/dev/null || {
    echo "Error: sudo access required but not available in non-interactive mode"
    exit 1
  }
fi

# Detect OS
if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "Darwin"
  export OS_TYPE=darwin
  source "$SCRIPT_PATH/darwin/init.sh"
elif [[ -f /etc/debian_version ]]; then
  echo "Debian"
  export OS_TYPE=debian
  source "$SCRIPT_PATH/debian/init.sh"
else
  echo "Unsupported OS: $(uname -a)"
  exit 1
fi

mkdir -p ~/Source ~/.ssh

# Setup gitconfig
if [[ ! -f ~/.gitconfig ]]; then
  cp $SCRIPT_PATH/gitconfig ~/.gitconfig
fi

if [[ ! -e ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

$SCRIPT_PATH/packages/rvm.sh
$SCRIPT_PATH/packages/fnm.sh
$SCRIPT_PATH/packages/docker.sh
$SCRIPT_PATH/packages/android.sh
$SCRIPT_PATH/packages/postgres.sh
$SCRIPT_PATH/packages/go.sh
$SCRIPT_PATH/packages/claude-code.sh
