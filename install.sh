#!/bin/bash

echo "Initialze emacs config"
git submodule init
git submodule update --checkout

echo "Link misc configs in home directory"
ln -s ~/.config/bash/bashrc ~/.bashrc
ln -s ~/.config/misc/xbindkeysrc ~/.xbindkeysrc
# ln -s ~/.config/misc/Xmodmap ~/.Xmodmap
