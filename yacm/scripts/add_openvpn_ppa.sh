#!/bin/bash

set -e;

VERSION="$1";

sudo apt --yes install apt-transport-https curl;

# This might not exist in all distributions
sudo mkdir -p /etc/apt/keyrings;

sudo bash -c 'curl -sSfL https://packages.openvpn.net/packages-repo.gpg > /etc/apt/keyrings/openvpn.asc';

if [ ! -f /etc/apt/sources.list.d/openvpn3.list ]; then
  sudo bash -c 'echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian noble main" >> /etc/apt/sources.list.d/openvpn3.list';

  sudo apt update;
fi

sudo apt --yes install openvpn3;
