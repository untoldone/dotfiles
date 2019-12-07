#!/usr/bin/env bash

set -e

case $OS_TYPE in
  debian)
    if [[ -f /usr/local/go/bin/go ]]; then
      echo "Go already installed"
      exit 0
    fi

    curl -O https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz
    tar xvf go1.13.5.linux-amd64.tar.gz
    rm go1.13.5.linux-amd64.tar.gz
    sudo chown -R root:root ./go
    sudo mv go /usr/local

    mkdir ~/go

    echo export GOPATH=$HOME/go >> ~/.zshrc
    echo export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin >> ~/.zshrc
    ;;
  darwin)
    echo "Currently no Darwin implementation"
    exit 1
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac
