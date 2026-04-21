#!/usr/bin/env bash

FIFO=$(mktemp -u /tmp/wifi_rofi_XXXXXX)
mkfifo "$FIFO"
trap "rm -f $FIFO" EXIT INT TERM

# Get current SSID
current=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# Format cached or live wifi list into display lines
format_wifi() {
    nmcli -t -f signal,ssid,security dev wifi list | \
        awk -F: '
        $2 != "" {
            if ($1 >= 80)      icon = "󰤨"
            else if ($1 >= 60) icon = "󰤥"
            else if ($1 >= 40) icon = "󰤢"
            else if ($1 >= 20) icon = "󰤟"
            else               icon = "󰤯"

            lock = ($3 != "" && $3 != "--") ? " 󰌾" : ""

            mark = ($2 == "'"$current"'") ? " •" : ""

            print icon " " $2 lock mark
        }' | sort -u
}

# Feed FIFO: cached list first (instant), then only NEW entries after rescan
{
    initial=$(format_wifi)
    [[ -n "$initial" ]] && printf '%s\n' "$initial"

    nmcli device wifi rescan 2>/dev/null

    updated=$(format_wifi)
    if [[ -n "$updated" ]]; then
        if [[ -n "$initial" ]]; then
            # Append only networks not already displayed
            comm -13 <(printf '%s\n' "$initial" | sort) \
                     <(printf '%s\n' "$updated" | sort)
        else
            printf '%s\n' "$updated"
        fi
    fi
} > "$FIFO" &
writer_pid=$!

# Show rofi immediately; it reads from FIFO and updates as new entries arrive
chosen=$(rofi -dmenu -i -p "Wi-Fi" -theme-str 'window {width: 360px;}' < "$FIFO")
kill "$writer_pid" 2>/dev/null
wait "$writer_pid" 2>/dev/null

[[ -z "$chosen" ]] && exit 0

# Extract SSID: strip icon prefix, lock/active mark suffixes
ssid=$(echo "$chosen" | sed 's/^[^ ]* //; s/ 󰌾$//; s/ •$//')

if [[ "$ssid" == "$current" ]]; then
    # Already connected, offer disconnect
    action=$(printf "Disconnect\nCancel" | rofi -dmenu -i -p "$ssid")
    [[ "$action" == "Disconnect" ]] && nmcli con down id "$ssid"
    exit 0
fi

# Try to connect (saved connections auto-authenticate)
if nmcli con up id "$ssid" 2>/dev/null; then
    notify-send "Wi-Fi" "Connected to $ssid"
else
    # Need password
    pass=$(rofi -dmenu -p "Password for $ssid" -password -theme-str 'window {width: 360px;}')
    if [[ -n "$pass" ]]; then
        if nmcli dev wifi connect "$ssid" password "$pass" 2>/dev/null; then
            notify-send "Wi-Fi" "Connected to $ssid"
        else
            notify-send "Wi-Fi" "Failed to connect to $ssid"
        fi
    fi
fi
