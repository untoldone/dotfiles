#!/usr/bin/env bash

set -e

curl -LO https://github.com/untoldone/dotfiles/archive/master.zip
unzip master.zip

cd dotfiles-master

./init.sh $1

cd ..
rm -rf dotfiles-master.zip