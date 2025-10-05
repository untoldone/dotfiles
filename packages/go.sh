#!/usr/bin/env bash

set -e

if [[ -f /usr/local/go/bin/go ]]; then
  echo "Go already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    export GO_INSTALL_FILE=go1.25.1.linux-amd64.tar.gz
    export GO_INSTALL_GROUP=root
    ;;
  darwin)
    export GO_INSTALL_FILE=go1.25.1.darwin-amd64.tar.gz
    export GO_INSTALL_GROUP=admin
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac

curl -O https://dl.google.com/go/$GO_INSTALL_FILE
tar xvf $GO_INSTALL_FILE
rm $GO_INSTALL_FILE
sudo chown -R root:$GO_INSTALL_GROUP ./go
sudo mv go /usr/local

mkdir -p ~/go

# Add Go to zshrc if not already present
if ! grep -q "GOPATH" ~/.zshrc 2>/dev/null; then
  echo 'export GOPATH=$HOME/go' >> ~/.zshrc
  echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.zshrc
fi