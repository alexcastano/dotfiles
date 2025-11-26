#!/bin/bash

# --- CONFIGURATION ---
CARD_NAME="bluez_card.58_18_62_17_69_14"
PROFILE_A2DP="a2dp_sink"
PROFILE_HFP="handsfree_head_unit"
# ---------------------

# Get the *current* active profile for the card
# Use awk for a more robust way to parse the pactl output
CURRENT_PROFILE=$(pactl list cards | awk -v card="$CARD_NAME" '
    $1 == "Name:" && $2 == card {
        in_card=1
    }
    in_card && $1 == "Active" && $2 == "Profile:" {
        print $3
        exit
    }
')

# Check if a profile was actually found
if [ -z "$CURRENT_PROFILE" ]; then
  echo "Error: Could not find card '$CARD_NAME' or read its active profile."
  echo "Please make sure your headphones are connected and try again."
  exit 1
fi

echo "Current profile: $CURRENT_PROFILE"

# Toggle between the two profiles
if [ "$CURRENT_PROFILE" = "$PROFILE_A2DP" ]; then
  echo "Switching to Handsfree (HFP)..."
  pactl set-card-profile "$CARD_NAME" "$PROFILE_HFP"
else
  echo "Switching to High Fidelity (A2DP)..."
  pactl set-card-profile "$CARD_NAME" "$PROFILE_A2DP"
fi

echo "Switch complete."
