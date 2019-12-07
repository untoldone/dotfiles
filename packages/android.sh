#!/usr/bin/env bash

set -e

case $OS_TYPE in
  debian)
    if [[ -f /usr/lib/android-sdk/platform-tools/adb ]]; then
      echo "Android tools already installed"
      exit 0
    fi

    sudo apt-get install -y android-sdk

    echo export ANDROID_HOME=/usr/lib/android-sdk >> ~/.zshrc

    ;;
  darwin)
    echo "Currently no Darwin implementation"
    exit 1
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac