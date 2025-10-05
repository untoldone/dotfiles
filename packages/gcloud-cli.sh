#!/usr/bin/env bash

set -e

if [[ $(which gcloud) ]]; then
  echo "Google Cloud CLI already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Add Google Cloud SDK repository
    if [[ ! -f /usr/share/keyrings/cloud.google.gpg ]]; then
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]]; then
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
      sudo apt-get update
    fi

    sudo apt-get install -y google-cloud-cli
    ;;
  darwin)
    brew install --cask google-cloud-sdk
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
