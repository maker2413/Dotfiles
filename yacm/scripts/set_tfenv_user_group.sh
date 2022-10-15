#!/bin/bash

TFENV_USER=$1;

if [[ -z $TFENV_USER ]]; then
  if [[ $(grep 'tfenv' /etc/group | grep $TFENV_USER) ]]; then
    echo -e "User: $TFENV_USER is in tfenv group already";
  else
    sudo usermod -aG tfenv $TFENV_USER
  fi
fi
