#!/bin/bash

# This script automatically changes wallpaper for Linux desktop using Hyprland as DP

WAIT=300
dir="${HOME}/background/desktop"
trans_type="any"

# Define the function for setting wallpapers in Hyprland
set_wallpaper_hyprland() {
    BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
    PROGRAM="swww-daemon"

    # Check if the program is running
    if pgrep "$PROGRAM" >/dev/null; then
        for dp in $(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}'); do
            BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
            swww img "$BG" --transition-fps 244 --transition-type "$trans_type" --transition-duration 1 -o "$dp"
        done
    else
        swww init
        for dp in $(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}'); do
            BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
            swww img "$BG" --transition-fps 244 --transition-type "$trans_type" --transition-duration 1 -o "$dp"
        done
    fi
}

# Main loop to check for monitor configuration changes and update wallpaper
while true; do
    initial_monitors=$(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}')

    set_wallpaper_hyprland

    # Wait for the specified amount of time or until a monitor configuration change
    for ((i=1; i<=WAIT; i++)); do
        current_monitors=$(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}')
        if [ "$initial_monitors" != "$current_monitors" ]; then
            echo "Monitor configuration changed. Breaking out of the loop."
            break
        fi
        sleep 1
    done
done
