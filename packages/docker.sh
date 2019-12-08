#!/usr/bin/env bash

set -e

if [[ $(which docker) ]]; then
  echo "Docker already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/debian \
         $(lsb_release -cs) \
         stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ;;
  darwin)
    brew install docker
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac