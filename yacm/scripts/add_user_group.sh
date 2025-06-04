#!/bin/bash

USER="$1";

GROUP="$2";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

# Print error if User not provided
if [[ -z "$USER" ]]; then
  echo -e "\e[31mUser not specified!\e[0m";
  exit 1;
fi

# Print error if Group not provided
if [[ -z "$GROUP" ]]; then
  echo -e "\e[31mGroup not specified!\e[0m";
  exit 1;
fi

grep "$GROUP" /etc/group | grep -q "$USER";
if [[ "$?" != 0 ]]; then
  echo -e "Adding \e[32m$USER\e[0m to group: \e[32m$GROUP\e[0m...";
  "$SUDO" usermod -aG "$GROUP" "$USER"
else
  echo -e "User \e[32m$USER\e[0m is in \e[32m$GROUP\e[0m group already";
fi
