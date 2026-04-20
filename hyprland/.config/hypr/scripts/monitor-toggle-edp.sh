#!/bin/bash
# Disable eDP-1 when an external monitor is connected; re-enable it when
# the last external monitor is disconnected. No-op on machines without an
# internal eDP panel (e.g. desktop towers).

# Exit if this machine has no internal laptop panel.
if ! compgen -G "/sys/class/drm/*-eDP-*" >/dev/null; then
  exit 0
fi

apply() {
  # Count monitors excluding eDP-1 from the live list
  local externals
  externals=$(hyprctl -j monitors all | jq -r '.[] | select(.name != "eDP-1") | .name' | wc -l)

  if [[ "$externals" -gt 0 ]]; then
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
