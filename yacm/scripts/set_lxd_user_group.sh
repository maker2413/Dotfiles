#!/bin/bash

LXD_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [[ ! -z "$LXD_USER" ]]; then
  grep lxd /etc/group | grep -q "$LXD_USER";
  if [[ "$?" != 0 ]]; then
    echo -e "Adding \e[32m$LXD_USER\e[0m to group lxd...";
    "$SUDO" usermod -aG lxd "$LXD_USER"
  else
    echo -e "User \e[32m$LXD_USER\e[0m is in lxd group already";
  fi
else
  echo -e "\e[31mUser not specified!\e[0m";
fi
