#!/usr/bin/env bash

set -e

if [[ $(which aws) ]]; then
  echo "AWS CLI already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "/tmp/awscliv2.zip"
    unzip -q -o /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/awscliv2.zip /tmp/aws
    ;;
  darwin)
    brew install awscli
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
