#!/bin/bash

set -e;

if [ ! "$(which k3s 2> /dev/null)" ]; then
  curl -sfL https://get.k3s.io | sh -
else
  echo -e "\e[32mk3s already installed! Skipping...\e[0m";
fi
