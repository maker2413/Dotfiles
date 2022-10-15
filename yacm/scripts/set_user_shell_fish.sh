#!/bin/sh

FISH_USER="$1";

if [[ ! -z "$FISH_USER" ]]; then
  if [[ $(cat /etc/passwd | grep "$FISH_USER" | awk -F: '{print $7}') != '/usr/bin/fish' ]]; then
    chsh -s /usr/bin/fish "$FISH_USER";
  else
    echo -e "User \e[32m$FISH_USER\e[0m already using fish shell";
  fi
else
  echo "User not defined";
fi
