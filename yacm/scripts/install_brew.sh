#!/bin/bash

set -e;

if [ ! "$(which brew 2> /dev/null)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "\e[32mbrew already installed! Skipping...\e[0m";
fi
