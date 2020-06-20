#!/bin/bash

##############################################################################
#  system_info.sh - This script handles installing prerequisites.
##############################################################################

function installPrerequisites {
  echo
  echo 'Checking if prerequisites need to be installed and installing if necessary...'
  echo

  # If apt-get is installed
  if hash apt-get &>/dev/null; then
    sudo -E apt-get update -y

    # make sure that aptitude is installed
    # "aptitude safe-upgrade" will upgrade the kernel
    if hash aptitude &>/dev/null; then
      sudo -E aptitude safe-upgrade
    else
      sudo -E apt-get aptitude -y
      sudo -E aptitude safe-upgrade
    fi

    sudo -E apt-get install littler -y

  # If yum is installed
  elif hash yum &>/dev/null; then
    sudo -E yum check-update -y
    sudo -E yum update -y
    sudo -E yum install littler -y

  # if zypper is installed
  elif hash zypper &>/dev/null; then
    sudo -E zypper -n install littler

  # If no supported package manager or no package manager
  else
    echo
    echo "*************************************************************************"
    echo "We couldn't find the appropriate package manager for your system. Please"
    echo "try manually installing the following and rerun this script:"
    echo
    echo "littler"
    echo "*************************************************************************"
    echo
  fi
  echo
}
