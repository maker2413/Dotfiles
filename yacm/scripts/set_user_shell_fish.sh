#!/bin/sh

FISH_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [[ ! -z "$FISH_USER" ]]; then
  if [[ $(cat /etc/passwd | grep "$FISH_USER" | awk -F: '{print $7}') != '/usr/bin/fish' ]]; then
    "$SUDO" chsh -s /usr/bin/fish "$FISH_USER";
  else
    echo -e "User \e[32m$FISH_USER\e[0m already using fish shell";
  fi
else
  echo -e "\e[31mUser not defined!\e[0m";
fi
