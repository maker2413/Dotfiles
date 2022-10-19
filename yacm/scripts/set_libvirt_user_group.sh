#!/bin/bash

LIBVIRT_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [[ ! -z "$LIBVIRT_USER" ]]; then
  grep libvirt /etc/group | grep -q "$LIBVIRT_USER";
  if [[ "$?" != 0 ]]; then
    echo -e "Adding \e[32m$LIBVIRT_USER\e[0m to group libvirt...";
    "$SUDO" usermod -aG libvirt "$LIBVIRT_USER"
  else
    echo -e "User \e[32m$LIBVIRT_USER\e[0m is in libvirt group already";
  fi
else
  echo -e "\e[31mUser not specified!\e[0m";
fi
