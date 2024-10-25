#!/bin/bash

set -e;

VERSION="$1";

sudo apt --yes install software-properties-common;

sudo add-apt-repository ppa:longsleep/golang-backports -y;

if [[ -z "$1" ]]; then
  sudo apt --yes install golang-$VERSION;
else
  sudo apt --yes install golang-go;
fi
