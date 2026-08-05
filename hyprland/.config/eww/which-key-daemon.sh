#!/bin/bash
# Which-key daemon - listens to Hyprland IPC for submap changes
# and shows/hides eww widget with keybinding hints

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_submap_bindings() {
    local submap="$1"
    # `hyprctl binds -j` is broken since Hyprland 0.56 (unquoted string values and
    # keys shifted against values => invalid JSON), so parse the plain-text output.
    # Records are separated by blank lines; fields are "\tname: value".
    # A non-empty description is equivalent to the old has_description filter.
    hyprctl binds | awk -v want="$submap" '
        function esc(s) { gsub(/\\/, "\\\\", s); gsub(/"/, "\\\"", s); return s }
        function flush() {
            if (submap == want && desc != "" && key != "ESCAPE" && key != "RETURN")
                printf "%s{\"key\":\"%s\",\"desc\":\"%s\"}", (n++ ? "," : ""), esc(key), esc(desc)
            submap = ""; key = ""; desc = ""
        }
        BEGIN { printf "[" }
        /^[^\t]/ { flush(); next }
        {
            field = substr($0, 2)
            sep = index(field, ": ")
            if (!sep) next
            name = substr(field, 1, sep - 1)
            value = substr(field, sep + 2)
            if (name == "submap") submap = value
            else if (name == "key") key = value
            else if (name == "description") desc = value
        }
        END { flush(); printf "]\n" }
    ' | jq -c 'unique_by(.key) | sort_by(.key | ascii_downcase)'
}

show_which_key() {
    local submap="$1"
    local keys_json
    keys_json=$(get_submap_bindings "$submap")

    # Skip if no bindings found (or the query failed)
    [[ -z "$keys_json" || "$keys_json" == "[]" ]] && return

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
