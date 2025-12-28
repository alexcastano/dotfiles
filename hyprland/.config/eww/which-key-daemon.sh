#!/bin/bash
# Which-key daemon - listens to Hyprland IPC for submap changes
# and shows/hides eww widget with keybinding hints

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_submap_bindings() {
    local submap="$1"
    hyprctl binds -j | jq -r --arg s "$submap" '
        [.[] | select(.submap == $s and .has_description == true and .key != "ESCAPE" and .key != "RETURN") | {key: .key, desc: .description}]
        | unique_by(.key)
        | sort_by(.key | ascii_downcase)
    '
}

show_which_key() {
    local submap="$1"
    local keys_json
    keys_json=$(get_submap_bindings "$submap")

    # Skip if no bindings found
    [[ "$keys_json" == "[]" ]] && return

    # Capitalize first letter
    local title="${submap^}"

    eww update submap_name="$title"
    eww update keys="$keys_json"
    eww open which-key
}

hide_which_key() {
    eww close which-key 2>/dev/null
}

# Listen to Hyprland events
socat -U - "UNIX-CONNECT:$SOCKET" | while read -r line; do
    # Event format: eventname>>data
    event="${line%%>>*}"
    data="${line#*>>}"

    if [[ "$event" == "submap" ]]; then
        if [[ -z "$data" || "$data" == "default" ]]; then
            hide_which_key
        else
            show_which_key "$data"
        fi
    fi
done
