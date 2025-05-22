#!/bin/bash

# iRemovalPRO v3.0 Serverless - Linux Device Checker

echo "iRemovalPRO v3.0 Serverless - Linux Edition"
echo "==========================================="

# Create directories for activation files and logs
mkdir -p ActivationFiles
mkdir -p Logs

echo "Checking for libimobiledevice tools..."

# Check if libimobiledevice tools are available
if [ -f "tools/iproxy" ]; then
    echo "iproxy: Available"
else
    echo "iproxy: Not found"
fi

if [ -f "tools/idevicepair" ]; then
    echo "idevicepair: Available"
else
    echo "idevicepair: Not found"
fi

if [ -f "tools/ideviceactivation" ]; then
    echo "ideviceactivation: Available"
else
    echo "ideviceactivation: Not found"
fi

# Try to list connected devices
echo -e "\nAttempting to list connected devices..."
if command -v idevice_id &> /dev/null; then
    DEVICES=$(idevice_id -l)
    if [ -z "$DEVICES" ]; then
        echo "No devices connected."
    else
        echo "Connected devices:"
        echo "$DEVICES"
    fi
else
    echo "Error: idevice_id command not found."
fi

echo -e "\nApplication is ready for use."
echo "Press Enter to exit..."
read
