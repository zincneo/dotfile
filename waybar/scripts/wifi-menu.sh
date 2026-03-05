#!/usr/bin/env bash

# Scan and list available WiFi networks
nmcli device wifi rescan 2>/dev/null

# Get current SSID
current=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

# List networks: signal icon + SSID + security
wifi_list=$(nmcli -t -f signal,ssid,security dev wifi list | \
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
    }' | sort -u)

if [[ -z "$wifi_list" ]]; then
    notify-send "Wi-Fi" "No networks found"
    exit 0
fi

# Show rofi menu
chosen=$(echo "$wifi_list" | rofi -dmenu -i -p "Wi-Fi" -theme-str 'window {width: 360px;}')

[[ -z "$chosen" ]] && exit 0

# Extract SSID: strip icon prefix, lock suffix, active mark
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
