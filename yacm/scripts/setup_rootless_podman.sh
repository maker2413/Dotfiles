#!/bin/bash

PODMAN_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

if [[ ! -z "$PODMAN_USER" ]]; then
  if [[ ! -f /etc/subuid ]]; then
    echo -e "Creating \e[32m/etc/subuid\e[0m...";
    echo -e "$PODMAN_USER:100000:65536" | $SUDO tee /etc/subuid >/dev/null;
  else
    echo -e "File \e[32m/etc/subuid\e[0m already defined. Skipping...";
  fi

  if [[ ! -f /etc/subgid ]]; then
    echo -e "Creating \e[32m/etc/subgid\e[0m...";
    echo -e "$PODMAN_USER:100000:65536" | $SUDO tee /etc/subgid >/dev/null;
  else
    echo -e "File \e[32m/etc/subuid\e[0m already defined. Skipping...";
  fi
else
  echo -e "\e[31mUser not specified!\e[0m";
fi
