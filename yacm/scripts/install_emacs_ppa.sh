#!/bin/bash

set -e;

sudo apt --yes install software-properties-common;

sudo add-apt-repository ppa:ubuntuhandbook1/emacs -y;

sudo DEBIAN_FRONTEND=noninteractive apt --yes install emacs;
