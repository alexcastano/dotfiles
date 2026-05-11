#!/bin/bash
# Disable eDP-1 only when a specific known external monitor is connected
# (matched by serial, so the port name doesn't matter). Other externals like
# projectors or meeting-room displays leave the laptop panel alone.
# No-op on machines without an internal eDP panel (e.g. desktop towers).

# Serial of the home monitor that should trigger the toggle.
TRIGGER_SERIAL="401NTQD3N604"  # LG UltraGear 4K

# Exit if this machine has no internal laptop panel.
if ! compgen -G "/sys/class/drm/*-eDP-*" >/dev/null; then
  exit 0
fi

apply() {
  local present
  present=$(hyprctl -j monitors all | jq -r --arg s "$TRIGGER_SERIAL" '[.[] | select(.serial == $s)] | length')

  if [[ "$present" -gt 0 ]]; then
    hyprctl keyword monitor "eDP-1, disable" >/dev/null
  else
    hyprctl keyword monitor "eDP-1, preferred, auto, 1" >/dev/null
  fi
}

# Apply once on startup
apply

# React to monitor hotplug events
socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
socat -U - UNIX-CONNECT:"$socket" | while read -r line; do
  case "$line" in
    monitoradded*|monitoraddedv2*|monitorremoved*|monitorremovedv2*)
      apply
      ;;
  esac
done
