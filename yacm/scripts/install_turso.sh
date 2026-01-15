#!/bin/bash

set -e;

if [ ! "$(which kubectl 2> /dev/null)" ]; then
  curl -sSfL https://get.tur.so/install.sh | bash
else
  echo -e "\e[32mturso already installed! Skipping...\e[0m"
fi
