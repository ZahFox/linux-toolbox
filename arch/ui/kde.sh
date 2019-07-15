#!/bin/bash

userdir="/home/$newuser"

packages="xorg-server \
  xorg-apps \
  xorg-xinit \
  sddm \
  plasma \
  kde-applications \
  firefox \
  latte-dock \
  kvantum-qt5 \
  plasma-nm \
  plasma-pa"

pacman --noconfirm -Syu $packages

systemctl enable sddm
