#!/bin/bash

set -e;

if [ ! "$(which paru 2> /dev/null)" ]; then
  sudo pacman -Sy base-devel --needed --noconfirm;
  git clone https://aur.archlinux.org/paru-bin.git;
  cd paru-bin;
  makepkg -si --noconfirm;
  cd ..;
  rm -rf paru-bin;
else
  echo -e "\e[32mparu already installed! Skipping...\e[0m";
fi

paru -S paru-bin --needed --noconfirm --skipreview;
