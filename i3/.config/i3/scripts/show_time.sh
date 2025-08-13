#!/bin/bash

# This file acts as a switch. If it exists, we show the date.
STATE_FILE="/tmp/i3blocks_time_show_date"

# On any click, toggle the state file's existence.
if [ -n "$BLOCK_BUTTON" ]; then
  if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
  else
    touch "$STATE_FILE"
  fi
fi

# Check if the state file exists and display the correct format.
if [ -f "$STATE_FILE" ]; then
  # State: Show full date and time
  echo "  $(date '+%Y/%m/%d %H:%M:%S')"
else
  # State: Show only time
  echo "  $(date '+%H:%M:%S')"
fi
