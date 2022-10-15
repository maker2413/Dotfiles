#!/bin/bash

TFENV_USER="$1";

if [[ ! -z "$TFENV_USER" ]]; then
  grep tfenv /etc/group | grep -q "$TFENV_USER";
  if [[ "$?" != 0 ]]; then
    echo -e "Adding \e[32m$TFENV_USER\e[0m to group tfenv...";
    sudo usermod -aG tfenv "$TFENV_USER"
  else
    echo -e "User \e[32m$TFENV_USER\e[0m is in tfenv group already";
  fi
else
  echo -e "\e[31mUser not defined\e[0m";
fi
