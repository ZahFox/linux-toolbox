#!/bin/bash

packages="xorg-server \
  xorg-apps \
  xorg-xinit \
  sddm \
  plasma \
  kde-applications \
  firefox \
  latte-dock"

pacman --noconfirm -Syu $packages

systemctl enable sddm