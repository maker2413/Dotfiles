#!/bin/bash

set -e

SERVICE=$1;

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

# Print error if Service not provided
if [[ -z "$SERVICE" ]]; then
  echo -e "\e[31mService not specified!\e[0m";
  exit 1;
fi

if [[ ! -f /run/runit/service/$SERVICE/down ]]; then
  echo -e "Disabling \e[32m$SERVICE\e[0m from autostarting...";
  "$SUDO" touch /run/runit/service/$SERVICE/down;
else
  echo -e "Service: \e[32m$SERVICE\e[0m already disabled!";
fi
