#!/usr/bin/env bash

set -e

# Check if RVM is already installed by looking for installation directory
if [[ -d /usr/local/rvm ]] || [[ -d ~/.rvm ]] || [[ -f /etc/profile.d/rvm.sh ]]; then
  echo "RVM already installed"
  exit 0
fi

\curl -sSL https://get.rvm.io | bash -s stable --autolibs=disable

# RVM can install to different locations, find it
if [ -f /usr/local/rvm/scripts/rvm ]; then
  source /usr/local/rvm/scripts/rvm
elif [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
elif [ -f /etc/profile.d/rvm.sh ]; then
  source /etc/profile.d/rvm.sh
else
  echo "RVM installed but cannot find rvm scripts"
  exit 1
fi

rvm install 3.4.6

# Add RVM to zshrc if not already present
if ! grep -q "rvm" ~/.zshrc 2>/dev/null; then
  if [ -f /usr/local/rvm/scripts/rvm ]; then
    echo 'source /usr/local/rvm/scripts/rvm' >> ~/.zshrc
  elif [ -f /etc/profile.d/rvm.sh ]; then
    echo 'source /etc/profile.d/rvm.sh' >> ~/.zshrc
  else
    echo 'source ~/.rvm/scripts/rvm' >> ~/.zshrc
  fi
fi