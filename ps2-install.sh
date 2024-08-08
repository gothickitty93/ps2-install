#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: sudo ps2-install <PS2_IP> <image|disc> <path_to_image_or_device>"
    exit 1
}

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    usage
fi

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    usage
fi

PS2_IP="$1"
TYPE="$2"
PATH="$3"

# Full paths to commands
BASENAME_CMD="/usr/bin/basename"
SED_CMD="/usr/bin/sed"
HDL_DUMP_CMD="/usr/local/bin/hdl_dump"
DISKUTIL_CMD="/usr/sbin/diskutil"
GREP_CMD="/usr/bin/grep"
AWK_CMD="/usr/bin/awk"

# Determine the name to use for the game
if [ "$TYPE" == "image" ]; then
    GAME_NAME=$($BASENAME_CMD "$PATH" | $SED_CMD 's/\.[^.]*$//')
    $HDL_DUMP_CMD inject_dvd "$PS2_IP" "$GAME_NAME" "$PATH"
elif [ "$TYPE" == "disc" ]; then
    # Check if the device exists
    if [ ! -e "$PATH" ]; then
        echo "The specified device does not exist."
        exit 1
    fi
    
    # Determine if the disc is a CD or DVD
    DISC_TYPE=$($DISKUTIL_CMD info "$PATH" | $GREP_CMD "Type (Bundle):" | $AWK_CMD '{print $3}')
    
    if [ "$DISC_TYPE" == "CD" ]; then
        GAME_NAME=$($DISKUTIL_CMD info "$PATH" | $GREP_CMD "Volume Name:" | $AWK_CMD '{print $3}')
        $HDL_DUMP_CMD inject_cd "$PS2_IP" "$GAME_NAME" "$PATH"
    elif [ "$DISC_TYPE" == "DVD" ]; then
        GAME_NAME=$($DISKUTIL_CMD info "$PATH" | $GREP_CMD "Volume Name:" | $AWK_CMD '{print $3}')
        $HDL_DUMP_CMD inject_dvd "$PS2_IP" "$GAME_NAME" "$PATH"
    else
        echo "Unable to determine disc type. Please ensure the disc is a valid CD or DVD."
        exit 1
    fi
else
    usage
fi

echo "Installation completed successfully."
