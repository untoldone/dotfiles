#!/usr/bin/env zsh

CI=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# RVM Dependencies
brew install autoconf automake libtool pkg-config coreutils libyaml libksba readline zlib openssl@1.1

# Allow unsigned to be open
sudo spctl --master-disable

# Install java
brew tap homebrew/cask
brew cask install --no-quarantine homebrew/cask-versions/adoptopenjdk8