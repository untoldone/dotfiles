#!/usr/bin/env bash

set -e

if [[ $(which psql) ]]; then
  echo "Postgres already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install PostgreSQL from official apt repository
    sudo apt-get install -y wget gnupg2
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
    sudo apt-get update
    sudo apt-get install -y postgresql-18 postgresql-client-18 libpq-dev

    ;;
  darwin)
    brew install postgresql@18
    # brew services start postgresql@17
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac