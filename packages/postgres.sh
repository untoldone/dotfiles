#!/usr/bin/env bash

set -e

case $OS_TYPE in
  debian)
    if [[ $(which psql) ]]; then
      echo "Postgres already installed"
      exit 0
    fi

    echo deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main | sudo tee -a /etc/apt/sources.list.d/pgdg.list
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y postgresql-11 postgresql-client-11 libpq-dev

    ;;
  darwin)
    echo "Currently no Darwin implementation"
    exit 1
    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac