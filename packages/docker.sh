#!/usr/bin/env bash

set -e

if [[ $(which docker) ]]; then
  echo "Docker already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install Docker using official repository
    sudo apt-get install -y ca-certificates gnupg lsb-release

    # Add Docker's official GPG key (if not already present)
    if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
    fi

    # Set up the repository (if not already present)
    if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
      ARCH=$(dpkg --print-architecture)
      echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
    fi

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ;;
  darwin)
    brew install --cask docker
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac