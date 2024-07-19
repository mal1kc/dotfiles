#!/bin/env dash

# switch case for $1

show_notification() {
	notify-send "$1" "$2" -i network-wireless -t 2000 -u normal
}

# Function to list available Wi-Fi networks
list_wifi_networks() {
	nmcli -t -f SSID,FREQ,SIGNAL,SECURITY device wifi list
}

# Function to connect to a selected Wi-Fi network
connect_to_wifi() {
	ssid="$1"
	nmcli device wifi connect "$ssid"
}

wifi_menu() {
	# Get list of available Wi-Fi networks
	# wifi_list=$(list_wifi_networks)
	#
	# list_of_options=$(echo "$wifi_list" | awk -F ':' '{print $1 with $3 ($2 , $4)}')
	#
	# selected_ssid=$(echo "$list_of_options" | wofi -d -p "Wi-Fi" -L 10 -i -p "Select Wi-Fi network" | awk '{print $1}')
	#
	# # Connect to the selected Wi-Fi network
	# if [ -n "$selected_ssid" ]; then
	# 	connect_to_wifi "$selected_ssid"
	# 	show_notification "Wi-Fi" "Connected to $selected_ssid"
	# else
	# 	show_notification "Wi-Fi" "No network selected"
	# fi
	show_notification "does't implemented" " doesn't implemented yet"

}

if command -v nmcli >/dev/null; then

	case "$1" in
	wifi-toggle)

		if [ "$(
			nmcli radio wifi
		)" = 'enabled' ]; then
			nmcli radio wifi off
			show_notification "Wifi" "Disabled"
		else
			nmcli radio wifi on
			show_notification "Wifi" "Enabled"
		fi
		;;
	wifi-list)
		wifi_menu
		;;
	open-nm)
		nm-connection-editor &
		show_notification "Network" "Manager"
		;;
	*)
		echo "unkown argument"
		;;
	esac
else
	echo "nmcli not found"
	exit 1

fi
