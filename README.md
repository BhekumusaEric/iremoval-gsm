# iRemovalPRO v3.0 Serverless

A completely offline iOS activation tool for jailbroken devices.

## Features

- **Completely Serverless**: Works without any internet connection or server dependencies
- **Local Activation**: Generates all activation records locally
- **Device Database**: Includes a comprehensive database of iOS devices for proper activation
- **Logging System**: Detailed logs for troubleshooting
- **Cached Activation Files**: Stores activation files for faster reactivation
- **Enhanced Error Handling**: Better error recovery and diagnostics

## Requirements

### For Windows:
- Windows PC
- Jailbroken iOS device (works best with checkra1n jailbreak)
- USB connection between PC and iOS device
- iTunes or Apple Mobile Device Support installed

### For Linux:
- Linux PC (Ubuntu, Fedora, Arch, or other distributions)
- Jailbroken iOS device (works best with checkra1n jailbreak)
- USB connection between PC and iOS device
- libimobiledevice installed
- .NET 6.0 runtime installed

## How to Use

### Windows:

1. **Connect your jailbroken iOS device** to your computer via USB
2. **Launch iRemovalPRO v3.0 Serverless.exe**
3. **Wait for device detection** - The application will automatically detect your device
4. **Click the "Activate" button** to start the activation process
5. **Wait for the process to complete** - The application will:
   - Generate activation records locally
   - Upload them to your device
   - Restart necessary services on your device
   - Complete the activation process
6. **Restart your device** when prompted

### Linux:

1. **Install dependencies**:
   ```bash
   # For Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install -y libimobiledevice-utils libusbmuxd-tools

   # For Fedora
   sudo dnf install -y libimobiledevice usbmuxd

   # For Arch Linux
   sudo pacman -S --noconfirm libimobiledevice usbmuxd
   ```

2. **Install .NET 6.0 runtime**:
   ```bash
   # For Ubuntu/Debian
   wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
   sudo dpkg -i packages-microsoft-prod.deb
   rm packages-microsoft-prod.deb
   sudo apt-get update
   sudo apt-get install -y apt-transport-https
   sudo apt-get update
   sudo apt-get install -y dotnet-sdk-6.0

   # For Fedora
   sudo dnf install -y dotnet-sdk-6.0

   # For Arch Linux
   sudo pacman -S --noconfirm dotnet-sdk
   ```

3. **Run the application**:
   ```bash
   chmod +x run.sh
   sudo ./run.sh
   ```

4. **Connect your jailbroken iOS device** to your computer via USB

5. **Follow the on-screen instructions**:
   - Press `1` to activate the device
   - Press `2` to check device status
   - Press `3` to deactivate the device
   - Press `4` to exit

## Troubleshooting

If you encounter issues during activation:

1. **Check the logs**: Look in the `Logs` folder for detailed information
2. **Verify jailbreak**: Make sure your device is properly jailbroken
3. **Reconnect device**: Try disconnecting and reconnecting your device
4. **Restart application**: Close and reopen iRemovalPRO
5. **Check permissions**: Make sure the application has proper permissions

## Important Notes

- **Do not update iOS**: Updating your iOS will remove the activation
- **Backup activation files**: The application stores activation files in the `ActivationFiles` folder
- **Compatible devices**: Works with most iOS devices that can be jailbroken
- **No internet required**: The application works completely offline

## Technical Details

The application works by:

1. Detecting your iOS device using LibiMobileDevice
2. Generating activation records based on your device's unique identifiers
3. Patching system files on your jailbroken device
4. Installing necessary components for activation
5. Restarting activation services

## Supported iOS Versions

The application includes support for iOS versions from 9.0 to 17.5.1, with proper build numbers for each version.

## Supported Devices

The application includes a database of device identifiers for:
- iPhone models from iPhone 6s to iPhone 15 Pro Max
- iPad models from iPad mini 4 to iPad Pro (6th generation)

## Credits

This serverless version was created to provide a more reliable activation solution that doesn't depend on external servers.

## Disclaimer

This tool is for educational purposes only. Use at your own risk.
