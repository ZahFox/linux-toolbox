#!/bin/bash

userdir="/home/$user"

packages="xorg-server \
  xorg-apps \
  xorg-xinit \
  sddm \
  plasma \
  kde-applications \
  firefox \
  latte-dock"

pacman --noconfirm -Syu $packages
echo "setxkbmap -option caps:swapescape" >> $userdir/.bashrc

systemctl enable sddm
