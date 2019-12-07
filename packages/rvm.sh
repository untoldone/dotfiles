#!/usr/bin/env bash

set -e

if [ -f ~/.rvm/bin/rvm ]; then
  echo "RVM already installed"
  exit 0
fi

curl -L https://get.rvm.io | bash -s -- --autolibs=read-fail

source ~/.rvm/scripts/rvm
rvm install 2.6.5

echo source ~/.rvm/scripts/rvm >> ~/.zshrc