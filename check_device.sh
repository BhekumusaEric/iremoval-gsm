#!/bin/bash

# iRemovalPRO v3.0 Serverless - Linux Device Checker

# Terminal colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create directories for activation files and logs
mkdir -p ActivationFiles
mkdir -p Logs

# Function to check tools
check_tools() {
    local tools_status=""

    # Check if libimobiledevice tools are available
    if [ -f "tools/iproxy" ]; then
        tools_status="${tools_status}iproxy: ${GREEN}Available${NC}\n"
    else
        tools_status="${tools_status}iproxy: ${RED}Not found${NC}\n"
    fi

    if [ -f "tools/idevicepair" ]; then
        tools_status="${tools_status}idevicepair: ${GREEN}Available${NC}\n"
    else
        tools_status="${tools_status}idevicepair: ${RED}Not found${NC}\n"
    fi

    if [ -f "tools/ideviceactivation" ]; then
        tools_status="${tools_status}ideviceactivation: ${GREEN}Available${NC}\n"
    else
        tools_status="${tools_status}ideviceactivation: ${RED}Not found${NC}\n"
    fi

    echo -e "$tools_status"
}

# Function to list connected devices
list_devices() {
    if command -v idevice_id &> /dev/null; then
        DEVICES=$(idevice_id -l)
        if [ -z "$DEVICES" ]; then
            echo -e "${YELLOW}No devices connected.${NC}"
        else
            echo -e "${GREEN}Connected devices:${NC}"
            echo -e "${BLUE}$DEVICES${NC}"
        fi
    else
        echo -e "${RED}Error: idevice_id command not found.${NC}"
    fi
}

# Function to get device info
get_device_info() {
    if command -v ideviceinfo &> /dev/null; then
        UDID=$(idevice_id -l | head -1)
        if [ -z "$UDID" ]; then
            echo -e "${YELLOW}No device connected.${NC}"
            return
        fi

        echo -e "${BLUE}Device Information:${NC}"
        echo -e "${GREEN}UDID:${NC} $UDID"

        if ideviceinfo -u "$UDID" &> /dev/null; then
            PRODUCT_TYPE=$(ideviceinfo -u "$UDID" | grep "ProductType" | awk '{print $2}')
            PRODUCT_VERSION=$(ideviceinfo -u "$UDID" | grep "ProductVersion" | awk '{print $2}')
            DEVICE_NAME=$(ideviceinfo -u "$UDID" | grep "DeviceName" | cut -d: -f2- | sed 's/^ //')
            SERIAL_NUMBER=$(ideviceinfo -u "$UDID" | grep "SerialNumber" | awk '{print $2}')

            echo -e "${GREEN}Model:${NC} $PRODUCT_TYPE"
            echo -e "${GREEN}iOS Version:${NC} $PRODUCT_VERSION"
            echo -e "${GREEN}Device Name:${NC} $DEVICE_NAME"
            echo -e "${GREEN}Serial Number:${NC} $SERIAL_NUMBER"
        else
            echo -e "${RED}Could not retrieve device information.${NC}"
        fi
    else
        echo -e "${RED}Error: ideviceinfo command not found.${NC}"
    fi
}

# Function to pair with device
pair_device() {
    if command -v idevicepair &> /dev/null; then
        echo -e "${BLUE}Attempting to pair with device...${NC}"
        RESULT=$(idevicepair pair)

        if [[ $RESULT == *"SUCCESS"* ]]; then
            echo -e "${GREEN}Device paired successfully!${NC}"
        else
            echo -e "${YELLOW}$RESULT${NC}"
            echo -e "${YELLOW}Please unlock your device and trust this computer.${NC}"
        fi
    else
        echo -e "${RED}Error: idevicepair command not found.${NC}"
    fi
}

# Function to activate device
activate_device() {
    echo -e "${BLUE}Activation feature is not yet implemented in this version.${NC}"
    echo -e "${YELLOW}This will be available in a future update.${NC}"
}

# Main menu function
show_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║       ${GREEN}iRemovalPRO v3.0 Serverless - Linux${BLUE}       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ ${GREEN}1.${NC} Check Tools Status                           ${BLUE}║${NC}"
    echo -e "${BLUE}║ ${GREEN}2.${NC} List Connected Devices                       ${BLUE}║${NC}"
    echo -e "${BLUE}║ ${GREEN}3.${NC} Show Device Information                      ${BLUE}║${NC}"
    echo -e "${BLUE}║ ${GREEN}4.${NC} Pair with Device                             ${BLUE}║${NC}"
    echo -e "${BLUE}║ ${GREEN}5.${NC} Activate Device                              ${BLUE}║${NC}"
    echo -e "${BLUE}║ ${GREEN}0.${NC} Exit                                         ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Please enter your choice [0-5]:${NC} "
    read -r choice

    case $choice in
        1) clear; echo -e "${BLUE}Checking Tools Status:${NC}\n"; check_tools; press_enter ;;
        2) clear; echo -e "${BLUE}Listing Connected Devices:${NC}\n"; list_devices; press_enter ;;
        3) clear; get_device_info; press_enter ;;
        4) clear; pair_device; press_enter ;;
        5) clear; activate_device; press_enter ;;
        0) clear; echo -e "${GREEN}Thank you for using iRemovalPRO v3.0 Serverless!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}"; press_enter ;;
    esac
}

# Function to prompt user to press enter
press_enter() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# Main loop
while true; do
    show_menu
done
