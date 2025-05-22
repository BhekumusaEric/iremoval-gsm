#!/bin/bash

# iRemovalPRO v3.0 Serverless - Linux Build Script
# This script builds the application for Linux

echo "Building iRemovalPRO v3.0 Serverless for Linux..."

# Check for .NET SDK
if ! command -v dotnet &> /dev/null; then
  echo ".NET SDK not found. Please install .NET 6.0 SDK."
  exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf bin/
rm -rf obj/
rm -rf publish/

# Restore packages
echo "Restoring packages..."
dotnet restore

# Build the application
echo "Building application..."
dotnet build -c Release

# Publish the application
echo "Publishing application..."
dotnet publish -c Release -r linux-x64 --self-contained false -o publish

# Create tools directory
echo "Creating tools directory..."
mkdir -p publish/tools

# Copy libimobiledevice tools
echo "Copying libimobiledevice tools..."
if command -v iproxy &> /dev/null; then
  cp $(which iproxy) publish/tools/
else
  echo "Warning: iproxy not found. Please install libimobiledevice."
fi

if command -v idevicepair &> /dev/null; then
  cp $(which idevicepair) publish/tools/
else
  echo "Warning: idevicepair not found. Please install libimobiledevice."
fi

if command -v ideviceactivation &> /dev/null; then
  cp $(which ideviceactivation) publish/tools/
else
  echo "Warning: ideviceactivation not found. Please install libimobiledevice-activation."
fi

# Copy run script
echo "Copying run script..."
cp run.sh publish/
chmod +x publish/run.sh

# Create directories for activation files and logs
echo "Creating directories for activation files and logs..."
mkdir -p publish/ActivationFiles
mkdir -p publish/Logs

echo "Build completed successfully!"
echo "The application is available in the 'publish' directory."
echo "To run the application, navigate to the 'publish' directory and run './run.sh'"
