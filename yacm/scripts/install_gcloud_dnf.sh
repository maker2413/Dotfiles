#!/bin/bash

set -e;

if [ ! -f /etc/yum.repos.d/google-cloud-sdk.repo ]; then
  sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
fi

if ! rpm -q libxcrypt-compat.x86_64 &> /dev/null; then
  sudo dnf install -y libxcrypt-compat.x86_64
else
  echo -e "\e[32mlibxcrypt-compat already installed! Skipping...\e[0m";
fi


if ! rpm -q google-cloud-cli &> /dev/null; then
  sudo dnf install -y google-cloud-cli
else
  echo -e "\e[32mgoogle-cloud-cli already installed! Skipping...\e[0m";
fi
