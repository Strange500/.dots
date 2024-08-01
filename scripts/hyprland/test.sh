for dp in $(hyprctl monitors | grep Monitor | awk -F'[ (]' '{print $2}'); do
	echo $dp
done
