#!/bin/bash
# A script to control system volume and screen brightness and show a notification.
# Uses pactl for volume and brightnessctl for brightness.

## --- CONFIGURATION ---
# Steps for increasing/decreasing volume and brightness
volume_step=2
brightness_step=5

# Notification timeout in milliseconds
notification_timeout=1000
## --- END CONFIGURATION ---


# Gets volume percentage from pactl
function get_volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Gets mute status from pactl
function get_mute {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

# Chooses a volume icon based on the current volume and mute status
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
        volume_icon="" # FontAwesome muted icon
    elif [ "$volume" -lt 50 ]; then
        volume_icon="" # FontAwesome low volume icon
    else
        volume_icon="" # FontAwesome high volume icon
    fi
}

# Gets brightness percentage from brightnessctl
function get_brightness {
    brightnessctl | grep -o '[0-9]*%' | sed 's/%//'
}

# Chooses a brightness icon
function get_brightness_icon {
    brightness_icon="" # FontAwesome sun icon
}

# Shows a volume notification
function show_volume_notif {
    volume=$(get_volume)
    get_volume_icon
    notify-send -t $notification_timeout \
        -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$volume" \
        "Volume" "$volume_icon   $volume%"
}

# Shows a brightness notification
function show_brightness_notif {
    brightness=$(get_brightness)
    get_brightness_icon
    notify-send -t $notification_timeout \
        -h string:x-dunst-stack-tag:brightness_notif \
        -h int:value:"$brightness" \
        "Brightness" "$brightness_icon   $brightness%"
}


# Main logic: reads the first argument to determine action
case $1 in
    volume_up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ "+$volume_step%"
        show_volume_notif
        ;;
    volume_down)
        pactl set-sink-volume @DEFAULT_SINK@ "-$volume_step%"
        show_volume_notif
        ;;
    volume_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;
    brightness_up)
        # Increase brightness using brightnessctl
        brightnessctl set "$brightness_step%+"
        show_brightness_notif
        ;;
    brightness_down)
        # Decrease brightness using brightnessctl
        brightnessctl set "$brightness_step%-"
        show_brightness_notif
        ;;
    *)
        echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down}"
        exit 1
        ;;
esac
