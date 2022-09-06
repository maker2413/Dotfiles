#!/bin/sh

set -e;

if [ ! "$(which paru 2> /dev/null)" ]; then
  sudo pacman -Sy base-devel --needed --noconfirm;
  git clone https://aur.archlinux.org/paru-bin.git;
  cd paru-bin;
  makepkg -si --noconfirm;
  cd ..;
  rm -rf paru-bin;
fi

paru -S paru-bin --needed --noconfirm --skipreview;
