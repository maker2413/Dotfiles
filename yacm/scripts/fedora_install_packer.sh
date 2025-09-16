#!/bin/bash

set -e;

if [ ! "$(which packer 2> /dev/null)" ]; then
  sudo dnf install -y dnf-plugins-core;
  sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo;
  sudo dnf -y install packer;
else
  echo -e "\e[32mpacker already installed! Skipping...\e[0m";
fi
