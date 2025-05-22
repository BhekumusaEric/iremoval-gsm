#!/bin/bash

# iRemovalPRO v3.0 Serverless - Linux GUI

# Create directories for activation files and logs
mkdir -p ActivationFiles
mkdir -p Logs

# Function to check tools
check_tools() {
    local tools_status=""
    
    # Check if libimobiledevice tools are available
    if [ -f "tools/iproxy" ]; then
        tools_status="${tools_status}iproxy: Available\n"
    else
        tools_status="${tools_status}iproxy: Not found\n"
    fi

    if [ -f "tools/idevicepair" ]; then
        tools_status="${tools_status}idevicepair: Available\n"
    else
        tools_status="${tools_status}idevicepair: Not found\n"
    fi

    if [ -f "tools/ideviceactivation" ]; then
        tools_status="${tools_status}ideviceactivation: Available\n"
    else
        tools_status="${tools_status}ideviceactivation: Not found\n"
    fi
    
    whiptail --title "Tools Status" --msgbox "$tools_status" 15 60
}

# Function to list connected devices
list_devices() {
    if command -v idevice_id &> /dev/null; then
        DEVICES=$(idevice_id -l)
        if [ -z "$DEVICES" ]; then
            whiptail --title "Connected Devices" --msgbox "No devices connected." 10 60
        else
            whiptail --title "Connected Devices" --msgbox "Connected devices:\n\n$DEVICES" 15 60
        fi
    else
        whiptail --title "Error" --msgbox "Error: idevice_id command not found." 10 60
    fi
}

# Function to get device info
get_device_info() {
    if command -v ideviceinfo &> /dev/null; then
        UDID=$(idevice_id -l | head -1)
        if [ -z "$UDID" ]; then
            whiptail --title "Device Information" --msgbox "No device connected." 10 60
            return
        fi
        
        local device_info="UDID: $UDID\n\n"
        
        if ideviceinfo -u "$UDID" &> /dev/null; then
            PRODUCT_TYPE=$(ideviceinfo -u "$UDID" | grep "ProductType" | awk '{print $2}')
            PRODUCT_VERSION=$(ideviceinfo -u "$UDID" | grep "ProductVersion" | awk '{print $2}')
            DEVICE_NAME=$(ideviceinfo -u "$UDID" | grep "DeviceName" | cut -d: -f2- | sed 's/^ //')
            SERIAL_NUMBER=$(ideviceinfo -u "$UDID" | grep "SerialNumber" | awk '{print $2}')
            
            device_info="${device_info}Model: $PRODUCT_TYPE\n"
            device_info="${device_info}iOS Version: $PRODUCT_VERSION\n"
            device_info="${device_info}Device Name: $DEVICE_NAME\n"
            device_info="${device_info}Serial Number: $SERIAL_NUMBER\n"
            
            whiptail --title "Device Information" --msgbox "$device_info" 15 60
        else
            whiptail --title "Error" --msgbox "Could not retrieve device information." 10 60
        fi
    else
        whiptail --title "Error" --msgbox "Error: ideviceinfo command not found." 10 60
    fi
}

# Function to pair with device
pair_device() {
    if command -v idevicepair &> /dev/null; then
        whiptail --title "Pairing" --infobox "Attempting to pair with device..." 10 60
        sleep 1
        RESULT=$(idevicepair pair)
        
        if [[ $RESULT == *"SUCCESS"* ]]; then
            whiptail --title "Pairing" --msgbox "Device paired successfully!" 10 60
        else
            whiptail --title "Pairing" --msgbox "$RESULT\n\nPlease unlock your device and trust this computer." 10 60
        fi
    else
        whiptail --title "Error" --msgbox "Error: idevicepair command not found." 10 60
    fi
}

# Function to activate device
activate_device() {
    whiptail --title "Activation" --msgbox "Activation feature is not yet implemented in this version.\n\nThis will be available in a future update." 10 60
}

# Function to show about information
show_about() {
    whiptail --title "About iRemovalPRO v3.0" --msgbox "iRemovalPRO v3.0 Serverless - Linux Edition\n\nA tool for managing iOS devices on Linux platforms.\n\nThis application allows you to:\n- Check for required tools\n- List connected devices\n- View device information\n- Pair with devices\n- Activate devices (coming soon)\n\nVersion: 3.0\nBuild: $(date +%Y%m%d)" 20 70
}

# Main menu function
show_menu() {
    CHOICE=$(whiptail --title "iRemovalPRO v3.0 Serverless - Linux" --menu "Choose an option:" 18 78 10 \
        "1" "Check Tools Status" \
        "2" "List Connected Devices" \
        "3" "Show Device Information" \
        "4" "Pair with Device" \
        "5" "Activate Device" \
        "6" "About" \
        "0" "Exit" 3>&1 1>&2 2>&3)
    
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $CHOICE in
            1) check_tools ;;
            2) list_devices ;;
            3) get_device_info ;;
            4) pair_device ;;
            5) activate_device ;;
            6) show_about ;;
            0) exit 0 ;;
        esac
    else
        exit 0
    fi
}

# Display welcome message
whiptail --title "Welcome" --msgbox "Welcome to iRemovalPRO v3.0 Serverless - Linux Edition!\n\nThis application allows you to manage iOS devices on Linux platforms." 12 70

# Main loop
while true; do
    show_menu
done
