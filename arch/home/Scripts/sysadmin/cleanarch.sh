#!/bin/bash

# manually clean the pacman cache
sudo pacman -Scc --noconfirm

# find unused pacman packages `sudo pacman -Qtdq`
sudo pacman -R $(sudo pacman -Qtdq) --noconfirm

# clean the home folder cache
rm -rf ~/.cache/*

rmlint --output=lint_file.sh /home
sh lint_file.sh -d
