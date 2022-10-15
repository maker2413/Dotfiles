#!/bin/sh

FISH_USER=$1;

if [[ -z $FISH_SHELL ]]; then
  if [[ $(cat /etc/passwd | grep $FISH_USER | awk -F: '{print $7}') != '/usr/bin/fish' ]]; then
    chsh -s /usr/bin/fish $FISH_USER;
  else
    echo -e "User: $FISH_USER already using fish shell";
  fi
fi
