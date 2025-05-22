#!/bin/bash

# iRemovalPRO v3.0 Serverless - Linux Launcher
# This script checks for dependencies and launches the application

# Note: For a real deployment, running as root would be required
# for USB device access, but we'll skip that check for this demo
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run as root (sudo ./run.sh)"
#   exit 1
# fi

# Check for required dependencies
echo "Checking dependencies..."

# Check for libimobiledevice
if ! command -v idevice_id &> /dev/null; then
  echo "libimobiledevice not found. Installing..."
  if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    apt-get update
    apt-get install -y libimobiledevice-utils libusbmuxd-tools
  elif command -v dnf &> /dev/null; then
    # Fedora
    dnf install -y libimobiledevice usbmuxd
  elif command -v pacman &> /dev/null; then
    # Arch Linux
    pacman -S --noconfirm libimobiledevice usbmuxd
  else
    echo "Could not install libimobiledevice. Please install it manually."
    exit 1
  fi
fi

# Check for .NET 6.0 runtime
if ! command -v dotnet &> /dev/null; then
  echo ".NET 6.0 runtime not found. Installing..."
  if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    apt-get update
    apt-get install -y apt-transport-https
    apt-get update
    apt-get install -y dotnet-sdk-6.0
  elif command -v dnf &> /dev/null; then
    # Fedora
    dnf install -y dotnet-sdk-6.0
  elif command -v pacman &> /dev/null; then
    # Arch Linux
    pacman -S --noconfirm dotnet-sdk
  else
    echo "Could not install .NET 6.0 runtime. Please install it manually."
    exit 1
  fi
fi

# Create tools directory if it doesn't exist
mkdir -p tools

# Check for iproxy
if [ ! -f "tools/iproxy" ]; then
  echo "iproxy not found. Copying from libimobiledevice..."
  if command -v iproxy &> /dev/null; then
    cp $(which iproxy) tools/iproxy
  else
    echo "iproxy not found. Please install libimobiledevice."
    exit 1
  fi
fi

# Check for idevicepair
if [ ! -f "tools/idevicepair" ]; then
  echo "idevicepair not found. Copying from libimobiledevice..."
  if command -v idevicepair &> /dev/null; then
    cp $(which idevicepair) tools/idevicepair
  else
    echo "idevicepair not found. Please install libimobiledevice."
    exit 1
  fi
fi

# Check for ideviceactivation
if [ ! -f "tools/ideviceactivation" ]; then
  echo "ideviceactivation not found. Copying from libimobiledevice..."
  if command -v ideviceactivation &> /dev/null; then
    cp $(which ideviceactivation) tools/ideviceactivation
  else
    echo "ideviceactivation not found. Please install libimobiledevice-activation."
    if command -v apt-get &> /dev/null; then
      apt-get install -y libimobiledevice-utils
    elif command -v dnf &> /dev/null; then
      dnf install -y libimobiledevice-utils
    elif command -v pacman &> /dev/null; then
      pacman -S --noconfirm libimobiledevice
    fi

    if command -v ideviceactivation &> /dev/null; then
      cp $(which ideviceactivation) tools/ideviceactivation
    else
      echo "Could not install ideviceactivation. Some features may not work."
    fi
  fi
fi

# Make tools executable
chmod +x tools/*

# Create directories for activation files and logs
mkdir -p ActivationFiles
mkdir -p Logs

# Run the application
echo "Starting iRemovalPRO v3.0 Serverless..."

# Check if whiptail is available for GUI
if command -v whiptail &> /dev/null; then
  if [ -f "iremoval_gui.sh" ]; then
    ./iremoval_gui.sh
  else
    echo "GUI not found. Falling back to CLI version."
    if [ -f "check_device.sh" ]; then
      ./check_device.sh
    else
      echo "Error: No interface scripts found."
      exit 1
    fi
  fi
else
  echo "Whiptail not found. Falling back to CLI version."
  if [ -f "check_device.sh" ]; then
    ./check_device.sh
  else
    echo "Error: No interface scripts found."
    exit 1
  fi
fi

echo "Application exited."
