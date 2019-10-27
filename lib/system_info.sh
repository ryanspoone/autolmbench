#!/bin/bash

##############################################################################
#  system_info.sh - This script handles the gathering the system information.
##############################################################################


##############################################################################
# Will display make, type, and model number
# ARM64 X-Gene1 Example: AArch64 Processor rev 0 (aarch64)
# Intel Example: Intel Xeon D-1540
# Power8 Example: ppc64le
##############################################################################
function getCPU {
  local arch

  CPU=$(grep -m 1 'model name' /proc/cpuinfo | sed 's/model name\s*\:\s*//g;s/(R)//g;s/ @.*//g;s/CPU //g;s/Genuine //g')

  if [ -z "$CPU" ]; then
    CPU=$(lscpu | grep -m 1 "Model name:" | sed 's/Model name:\s*//g;s/(R)//g;s/ @.*//g;s/CPU //g;s/Genuine //g')
  fi

  if [ -z "$CPU" ]; then
    CPU=$(lscpu | grep -m 1 "CPU:" | sed 's/CPU:\s*//g;s/(R)//g;s/ @.*//g;s/CPU //g;s/Genuine //g')
  fi

  if [ -z "$CPU" ]; then
    arch=$(lscpu | grep -m 1 "Architecture:" | sed 's/Architecture:\s*//g;s/x86_//;s/i[3-6]86/32/'  | tr '[:upper:]' '[:lower:]')

    if [[ $arch == *'aarch'* || $arch == *'arm'* ]]; then
      CPU='Unknown ARM'
    elif [[ $arch == *'ppc'* ]]; then
      CPU='Unknown PowerPC'
    elif [[ $arch == *'x86_64'* || $arch == *'32'* ]]; then
      CPU='Unknown Intel'
    else
      CPU='Unknown CPU'
    fi
  fi

  export CPU
}


############################################################
# Get OS and version
# Example OS: Ubuntu
# Example VER: 14.04
############################################################
function getOS {
  if [ -f /etc/lsb-release ]; then
    # shellcheck disable=SC1091,SC1090
    source /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    OS='Debian'
    VER=$(cat /etc/debian_version)
  elif [ -f /etc/redhat-release ]; then
    OS='Redhat'
    VER=$(cat /etc/redhat-release)
  else
    OS=$(uname -s)
    VER=$(uname -r)
  fi

  export OS
  export VER
}


##############################################################################
# Detect OS architecture
# Displays bits, either 64 or 32
##############################################################################
function getArch {
  ARCH=$(lscpu | grep -m 1 "Architecture:" | sed 's/Architecture:\s*//g;s/x86_//;s/i[3-6]86/32/' | tr '[:upper:]' '[:lower:]')

  # If it is an ARM system
  if [[ $ARCH == *'arm'* ]]; then
    # Get the ARM version number
    ARM_V=$(echo -n "$ARCH" | sed 's/armv//g' | head -c1)

    # If ARMv8 or greater, set to 62 bit
    if [[ "$ARM_V" -ge 8 ]]; then
      ARCH='64'
    else
      ARCH='32'
    fi
  fi

  if [[ $ARCH == *'aarch64'* || $ARCH == *'ppc64le'* ]]; then
    ARCH='64'
  fi

  if [ -z "$ARCH" ]; then
    echo
    echo "Unable to detect system architecture."
    echo
    echo -n "How many bits are in your system architecture (64 or 32)? "
    read -r ARCH
  fi

  export ARCH
}


##############################################################################
# Virtual cores / logical cores / threads
##############################################################################
function getThreads {
  if hash lscpu &>/dev/null; then
    PHYSICAL_PROCESSORS=$(lscpu | grep -m 1 "Socket(s):" | sed 's/Socket(s):\s*//g')
    THREADS_PER_CORE=$(lscpu | grep -m 1 "Thread(s) per core:" | sed 's/Thread(s) per core:\s*//g')
    CORES=$(lscpu | grep -m 1 "Core(s) per socket:" | sed 's/Core(s) per socket:\s*//g')
  else
    echo
    echo -n "How many threads per core? "
    read -r THREADS_PER_CORE
    echo
    echo
    echo -n "How many sockets (physical processors)? "
    read -r PHYSICAL_PROCESSORS
    echo
    echo
    echo -n "How many cores per socket? "
    read -r CORES
    echo
  fi

  TOTAL_CORES=$((PHYSICAL_PROCESSORS * CORES))
  LOGICAL_CORES=$((THREADS_PER_CORE * TOTAL_CORES))

  export LOGICAL_CORES
}


############################################################
# Function to get all system information
############################################################
function getSystemInfo {
  getCPU
  getOS
  getArch
  getThreads
}
