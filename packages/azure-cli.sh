#!/usr/bin/env bash

set -e

if [[ $(which az) ]]; then
  echo "Azure CLI already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install Azure CLI using official install script
    # This method works across all Debian versions including Trixie
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    ;;
  darwin)
    brew install azure-cli
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
