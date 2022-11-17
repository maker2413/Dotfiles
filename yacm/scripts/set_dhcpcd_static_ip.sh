#!/bin/bash

NETWORK_DEVICE="$1";
STATIC_IP="$2";
ROUTER_IP="${3:-192.168.0.1}"

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

# Print error if Network Device not provided
if [[ -z "$NETWORK_DEVICE" ]]; then
  echo -e "\e[31mNetwork device not specified!\e[0m";
  exit 1;
fi

# Print error if Static IP not provided
if [[ -z "$STATIC_IP" ]]; then
  echo -e "\e[31mStatic IP not specified!\e[0m";
  exit 1;
fi

echo -e "Setting static ip of \e[32m$NETWORK_DEVICE\e[0m to: \e[32m$STATIC_IP\e[0m";
grep -q "interface $NETWORK_DEVICE" /etc/dhcpcd.conf || $SUDO tee -a /etc/dhcpcd.conf >/dev/null << EOF

interface $NETWORK_DEVICE
static ip_address=$STATIC_IP
static routers=$ROUTER_IP
static domain_name_servers=$ROUTER_IP
EOF
