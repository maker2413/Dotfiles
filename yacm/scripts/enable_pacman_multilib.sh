#!/bin/bash

set -e

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

grep -qxF '[multilib]' /etc/pacman.conf || $SUDO tee -a /etc/pacman.conf >/dev/null << 'EOF'

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
