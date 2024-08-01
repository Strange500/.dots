#!/bin/bash

# Get the current desktop session
current_session=$XDG_CURRENT_DESKTOP

# Define the function for setting wallpapers in XFCE
set_wallpaper_xfce() {
	dir="${HOME}/background/desktop"
	monitor="$(xrandr --query | grep " connected" | cut -d" " -f1)"
	RANDFILE=$(find "$dir" -type f -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" | shuf -n1)
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor"$monitor"/workspace0/last-image -s "${RANDFILE}"
}

# Define the function for setting wallpapers in Hyprland
set_wallpaper_hyprland() {
	dir="${HOME}/background/desktop"
	BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
	PROGRAM="swww-daemon"
	trans_type="any"

	# Check if the program is running
	if pgrep "$PROGRAM" >/dev/null; then
#		swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1 -o DP-2
#		BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
#		swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1 -o HDMI-A-1
		for dp in $(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}'); do
			BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
         		swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1 -o $dp
 		done
	else
		swww init && swww img "$BG" --transition-fps 244 --transition-type $trans_type --transition-duration 1
	fi
}

# Define the function for setting wallpapers in other sessions
set_wallpaper_other() {
	dir="${HOME}/.local/share/walls"
	BG="$(find "$dir" -name '*.jpg' -o -name '*.png' | shuf -n1)"
	cat "$BG" > ~/.local/share/walls/wallpaper.jpg
	xwallpaper --zoom "$BG"
}

# Check the current session and run the appropriate function
while true; do
    test=$(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}')
    # Check the current session and run the appropriate function
    case "$current_session" in
    "XFCE")
        set_wallpaper_xfce
        ;;
    "Hyprland")
        set_wallpaper_hyprland
        ;;
    *)
        set_wallpaper_other
        ;;
    esac

    
    # Wait for a specified amount of time before changing the wallpaper again
    for i in {1..300}; do
        verif=$(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}')
        if [ "$test" != "$verif" ]; then
            echo "Monitor configuration changed. Breaking out of the loop."
            break
        fi
        sleep 1
    done

done
