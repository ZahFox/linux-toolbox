#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
TITLE="Please Choose an Installer"
MENU="The following are your available options..."

OPTIONS=(1 "server"
         2 "i3"
	 3 "kde"
	 4 "exit")

CHOICE=$(dialog --timeout 10  --title "$TITLE" \
       	--menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" \
	3>&1 1>&2 2>&3)

EXIT_CODE=$?
clear

# If the dialog times out, default to the server installer
case $EXIT_CODE in
  255)
    CHOICE=1
    ;;
esac

case $CHOICE in
  1)
    echo "Beginning server installer..."
    source '/scripts/installer_functions.sh'
    baseline_install
    finish_install
    ;;
  2)
    echo "Beginning i3 installer..."
    ;;
  3)
    echo "Beginning kde installer..."
    ;;
  4)
    echo "Thanks. Maybe next time?"
    ;;
esac

