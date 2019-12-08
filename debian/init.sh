#!/usr/bin/env bash

set -e

sudo -S apt-get update

# Update existing packages
yes '' | sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confnew" dist-upgrade

# General tools
sudo apt-get install -y zsh curl apt-transport-https unzip ntp dbus software-properties-common openjdk-11-jdk jq

# Switch shell
sudo sed -i 's/required   pam_shells.so/sufficient   pam_shells.so/g' /etc/pam.d/chsh
chsh -s /bin/zsh
sudo sed -i 's/sufficient   pam_shells.so/required   pam_shells.so/g' /etc/pam.d/chsh

touch ~/.zshrc

# RVM Dependencies
sudo apt-get install -y gawk bison libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libyaml-dev pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev

sudo cp ./debian/apt-10periodic /etc/apt/apt.conf.d/10periodic

# Timezone
sudo ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata
