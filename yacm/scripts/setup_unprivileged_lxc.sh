#!/bin/bash

set -e;
# PODMAN_USER="$1";

# SUDO is used to determine if yacm is being run by root or not
SUDO='';
if [[ $EUID != 0 ]]; then
  SUDO='sudo';
fi

# echo "Setting up /etc/lxc/default.conf...";
# grep -qxF 'lxc.idmap = u' /etc/lxc/default.conf || sudo tee -a /etc/lxc/default.conf >/dev/null << 'EOF'

# # unprivileged lxc configuration
# lxc.idmap = u 0 100000 65536
# EOF

# grep -qxF 'lxc.idmap = g' /etc/lxc/default.conf || sudo tee -a /etc/lxc/default.conf >/dev/null << 'EOF'

# # unprivileged lxc configuration
# lxc.idmap = g 0 100000 65536
# EOF

if [[ ! -f /etc/subuid ]]; then
  echo -e "Creating \e[32m/etc/subuid\e[0m...";
  echo "root:1000000:1000000000" | $SUDO tee /etc/subuid >/dev/null;
else
  echo -e "File \e[32m/etc/subuid\e[0m already defined. Skipping...";
fi

if [[ ! -f /etc/subgid ]]; then
  echo -e "Creating \e[32m/etc/subgid\e[0m...";
  echo "root:1000000:1000000000" | $SUDO tee /etc/subgid >/dev/null;
else
  echo -e "File \e[32m/etc/subuid\e[0m already defined. Skipping...";
fi
