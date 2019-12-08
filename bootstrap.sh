#!/usr/bin/env bash

set -e

echo "Sudo password?"
read PASS

git clone https://github.com/untoldone/dotfiles.git

cd dotfiles

./init.sh $PASS

cd ..
rm -rf dotfiles