#!/usr/bin/env bash

set -e

UNAME="$(uname -a)"
SCRIPT_PATH="$(dirname $0)"

cd $SCRIPT_PATH

# Ask for the administrator password upfront
echo $1 | sudo -S -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

case $UNAME in
  *Debian*)
    echo "Debian"
    export OS_TYPE=debian
    source "$SCRIPT_PATH/debian/init.sh"
    ;;
  *Darwin*)
    echo "Darwin"
    export OS_TYPE=darwin
    source "$SCRIPT_PATH/darwin/init.sh"
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac

mkdir -p ~/Source ~/.ssh

if [[ ! -e ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

$SCRIPT_PATH/packages/rvm.sh
$SCRIPT_PATH/packages/nvm.sh
$SCRIPT_PATH/packages/docker.sh
$SCRIPT_PATH/packages/android.sh
$SCRIPT_PATH/packages/postgres.sh
$SCRIPT_PATH/packages/go.sh
