#!/usr/bin/env bash

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
if [[ -z "$BAT_PATH" ]]; then
    echo '{"text": "", "tooltip": "No battery", "class": "none"}'
    exit 0
fi

capacity=$(cat "$BAT_PATH/capacity")
status=$(cat "$BAT_PATH/status")

# icon (nf-md-battery)
if [[ "$status" == "Charging" ]]; then
    icon="󰂄"
elif ((capacity <= 10)); then
    icon="󰁺"
elif ((capacity <= 30)); then
    icon="󰁼"
elif ((capacity <= 60)); then
    icon="󰁿"
elif ((capacity <= 90)); then
    icon="󰂁"
else
    icon="󰁹"
fi

# css class
class="normal"
if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
    class="charging"
elif ((capacity <= 15)); then
    class="critical"
elif ((capacity <= 30)); then
    class="warning"
fi

printf '{"text": "%s %d%%", "tooltip": "%s: %d%%", "class": "%s"}\n' \
    "$icon" "$capacity" "$status" "$capacity" "$class"
