#!/bin/sh

if [[ $(cat /etc/passwd | grep $USER | awk -F: '{print $7}') != '/usr/bin/fish' ]]; then
  chsh -s /usr/bin/fish;
fi
