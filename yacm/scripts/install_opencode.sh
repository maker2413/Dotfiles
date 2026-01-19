#!/bin/bash

set -e;

if [ ! "$(which opencode 2> /dev/null)" ]; then
  curl -fsSL https://opencode.ai/install | bash
else
  echo -e "\e[32mopencode already installed! Skipping...\e[0m";
fi
