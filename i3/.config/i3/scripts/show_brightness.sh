#!/bin/bash

# First, check if a brightness-controllable device exists.
# We suppress all output from this check.
if ! brightnessctl get >/dev/null 2>&1; then
    # If the command fails, no device was found. Exit gracefully.
    exit 0
fi

# If a device exists, get its brightness percentage.
BRIGHTNESS=$(brightnessctl | grep -o '[0-9]*%' | head -n 1)

# Print the icon and brightness for the i3blocks bar.
echo "  $BRIGHTNESS"
