#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar.log /tmp/polybar2.log
polybar main >>/tmp/polybar.log 2>&1 &
polybar secondary >>/tmp/polybar2.log 2>&1 &

echo "Bars launched..."
