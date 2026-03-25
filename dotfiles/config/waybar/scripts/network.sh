#!/usr/bin/env bash

check_network() {
	local net_status="disconnected"
	local net_icon=" 󰖪 "
	local net_class="disconnected"
	local tooltip="Network: Disconnected"

	if command -v iwctl &>/dev/null; then
		local device
		device=$(iwctl device list 2>/dev/null | grep 'wlan' | head -1 | awk '{print $2}')

		if [[ -n "$device" ]]; then
			local state
			state=$(iwctl station "$device" show 2>/dev/null | grep "State" | awk '{print $2}')

			if [[ "$state" == "connected" ]]; then
				local net_ssid
				net_ssid=$(iwctl station "$device" show 2>/dev/null | grep "Connected network" | awk '{print $3}')

				if [[ -n "$net_ssid" ]]; then
					net_status="connected"
					net_icon=" 󰤨 "
					net_class="connected"

					local signal freq ip
					signal=$(iwctl station "$device" show 2>/dev/null | grep "RSSI" | head -1 | awk '{print $2" "$3}')
					freq=$(iwctl station "$device" show 2>/dev/null | grep "Frequency" | awk '{print $2}')
					ip=$(ip addr show 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | head -1 | awk '{print $2}')

					tooltip="Network: Connected\nSSID: $net_ssid\nSignal: $signal\nFrequency: ${freq}MHz\nIP: ${ip:-N/A}"
				else
					net_status="connecting"
					net_icon=" 󰤨 "
					net_class="connecting"
					tooltip="Network: Connecting..."
				fi
			elif [[ "$state" == "connecting" ]]; then
				net_status="connecting"
				net_icon=" 󰤨 "
				net_class="connecting"
				tooltip="Network: Connecting..."
			fi
		fi
	fi

	echo "{\"text\": \"$net_icon\", \"class\": \"$net_class\", \"tooltip\": \"$tooltip\"}"
}

check_network
