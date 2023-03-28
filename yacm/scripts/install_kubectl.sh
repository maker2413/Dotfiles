#!/bin/bash

set -e;

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [ ! "$(which kubectl 2> /dev/null)" ]; then
  $SUDO curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --output /usr/bin/kubectl;
else
  echo -e "\e[32mkubectl already installed! Skipping...\e[0m";
fi
