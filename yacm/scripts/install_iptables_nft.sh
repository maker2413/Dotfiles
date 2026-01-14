#!/bin/bash

set -e;

if [ ! "$(paru -Q iptables-nft)" ]; then
  yes | paru -S iptables-nft
else
  echo "iptables-nft already installed... skipping";
fi
