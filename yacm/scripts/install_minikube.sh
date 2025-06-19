#!/bin/bash

set -e;

if [ ! "$(which minikube 2> /dev/null)" ]; then
  curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64;

  sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
else
  echo -e "\e[32mminikube already installed! Skipping...\e[0m";
fi
