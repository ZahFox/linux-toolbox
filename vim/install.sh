#!/bin/bash

# The directory that this script is in
VIM_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -z "$HOME" ]
then
    INSTALL_DIR=$HOME
else
    INSTALL_DIR="/home/$(whoami)"
fi

echo "Installing Vim configuration in the following directory: $INSTALL_DIR"

mkdir -p $INSTALL_DIR/.vim
cp $VIM_DIR/.vimrc $INSTALL_DIR/.vimrc
cp -r $VIM_DIR/.vim/* $INSTALL_DIR/.vim/