#!/usr/bin/env bash

check_bluetooth() {
	local bt_icon="󰂲"
	local bt_class="off"
	local tooltip="Bluetooth: Off"

	if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
		bt_icon=""
		bt_class="on"

		local connected_devices=()
		local bt_macs
		bt_macs=$(bluetoothctl devices 2>/dev/null | awk '{print $2}')

		for mac in $bt_macs; do
			if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
				local name
				name=$(bluetoothctl info "$mac" 2>/dev/null | grep "Name:" | cut -d' ' -f2-)
				if [[ -n "$name" ]]; then
					connected_devices+=("$name")
				fi
			fi
		done

		if [[ ${#connected_devices[@]} -gt 0 ]]; then
			bt_icon="󰂱"
			bt_class="connected"
			tooltip="Bluetooth: Connected (${#connected_devices[@]})\n"
			for i in "${!connected_devices[@]}"; do
				tooltip+="${connected_devices[$i]}"
				if [[ $i -lt $((${#connected_devices[@]} - 1)) ]]; then
					tooltip+="\n"
				fi
			done
		else
			tooltip="Bluetooth: On\nNo devices connected"
		fi
	fi

	echo "{\"text\": \"$bt_icon\", \"class\": \"$bt_class\", \"tooltip\": \"$tooltip\"}"
}

check_bluetooth
