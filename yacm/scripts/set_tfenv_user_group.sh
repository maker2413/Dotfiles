#!/bin/bash

TFENV_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [[ ! -z "$TFENV_USER" ]]; then
  grep tfenv /etc/group | grep -q "$TFENV_USER";
  if [[ "$?" != 0 ]]; then
    echo -e "Adding \e[32m$TFENV_USER\e[0m to group tfenv...";
    "$SUDO" usermod -aG tfenv "$TFENV_USER"
  else
    echo -e "User \e[32m$TFENV_USER\e[0m is in tfenv group already";
  fi
else
  echo -e "\e[31mUser not specified!\e[0m";
fi
