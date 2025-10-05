#!/usr/bin/env bash

set -e

if [[ $(which az) ]]; then
  echo "Azure CLI already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install dependencies
    sudo apt-get install -y ca-certificates apt-transport-https lsb-release gnupg

    # Add Microsoft signing key
    if [[ ! -f /etc/apt/keyrings/microsoft.gpg ]]; then
      sudo mkdir -p /etc/apt/keyrings
      curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
      sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
    fi

    # Add Azure CLI repository
    if [[ ! -f /etc/apt/sources.list.d/azure-cli.sources ]]; then
      AZ_DIST=$(lsb_release -cs)
      # Use bookworm for Debian Trixie since Azure CLI doesn't support it yet
      if [[ "$AZ_DIST" == "trixie" ]]; then
        AZ_DIST="bookworm"
      fi
      echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources > /dev/null
      sudo apt-get update
    fi

    sudo apt-get install -y azure-cli
    ;;
  darwin)
    brew install azure-cli
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
