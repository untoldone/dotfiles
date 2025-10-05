#!/usr/bin/env bash

set -e

# Install prerequisites if needed (Debian/Ubuntu)
if [[ -f /etc/debian_version ]]; then
  if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    apt-get update && apt-get install -y unzip
  fi
  if ! command -v sudo &> /dev/null; then
    echo "Installing sudo..."
    apt-get install -y sudo
  fi
fi

curl -LO https://github.com/untoldone/dotfiles/archive/master.zip
unzip master.zip

cd dotfiles-master

./init.sh $1

cd ..
rm -rf dotfiles-master.zip