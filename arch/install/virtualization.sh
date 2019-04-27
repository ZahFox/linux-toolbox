#!/bin/bash

function is_installed {
  if $(sudo pacman -Qi $1 &> /dev/null); then
    echo "TRUE"
    return
  else
    echo "FALSE"
    return
  fi  
}

function install_if_not_exists {
  local package=$1
  local result=$(is_installed $package)

  if [ $result == "FALSE" ]; then
    sudo pacman --noconfirm -Syu $package
  else
    echo "warning: $package is already installed"
  fi  

  return 0
}

function virtualization_checker {
  local test_file=/proc/scsi/scsi
  
  if [ ! -f $test_file ]; then
    echo "NULL"
    return
  else
    local vbox_test=$(grep VBOX $test_file)
    local vmware_test=$(grep VMware $test_file)

    if [ ! -z "$vbox_test" ]; then
      echo "VBOX"
      return
    fi

    if [ ! -z "$vmware_test" ]; then
      echo "VMWARE"
      return
    fi

    echo "NULL"
    return
  fi
}


function install_virtualbox_guest_tools {
  install_if_not_exists "virtualbox-guest-utils"
}

function install_vmware_guest_tools {
  # Manual Way
  #   local install_dir=/tmp/vmware_guest_tools_install
  #   mkdir -p $install_dir
  #   pushd $install_dir
  #   git clone https://github.com/rasa/vmware-tools-patches.git
  #   cd vmware-tools-patches
  #   ./patched-open-vm-tools.sh
  #   popd
  #   rm -rf $install_dir

  install_if_not_exists "open-vm-tools"
}
