#!/usr/bin/env bash

set -e

# Install prerequisites if needed (Debian/Ubuntu)
if [[ -f /etc/debian_version ]]; then
  if ! command -v sudo &> /dev/null; then
    echo "sudo is not installed. Installing it now..."
    if [[ $EUID -eq 0 ]]; then
      # Already root, just install
      apt-get update && apt-get install -y sudo
    else
      # Not root, use su to become root
      echo "This requires root access. You will be prompted for the root password."
      su -c "apt-get update && apt-get install -y sudo && usermod -aG sudo $USER" root
      echo "sudo has been installed and your user added to the sudo group."
      echo "You may need to log out and back in for group changes to take effect."
      echo "Continuing with installation..."
    fi
  fi

  if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    sudo apt-get update && sudo apt-get install -y unzip
  fi
fi

curl -LO https://github.com/untoldone/dotfiles/archive/master.zip
unzip master.zip

cd dotfiles-master

./init.sh

cd ..
rm -rf dotfiles-master.zip