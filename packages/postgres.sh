#!/usr/bin/env bash

set -e

if [[ $(which psql) ]]; then
  echo "Postgres already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    echo deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main | sudo tee -a /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y postgresql-11 postgresql-client-11 libpq-dev

    ;;
  darwin)
    brew install postgresql
    # brew services start postgresql
    # pg_ctl -D /usr/local/var/postgres start
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac