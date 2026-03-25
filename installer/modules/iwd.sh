#!/usr/bin/env bash

iwd_init() {
	log STEP "Initializing iwd module"
}

iwd_validate() {
	[ "$ENABLE_IWD" = true ]
}

iwd_run() {
	# Copy iwd config to /etc/iwd/main.conf
	local iwd_conf="$DOTFILES_DIR/config/iwd/main.conf"

	if [ -f "$iwd_conf" ]; then
		run sudo mkdir -p /etc/iwd
		run sudo cp "$iwd_conf" /etc/iwd/main.conf
		log OK "iwd config installed to /etc/iwd/main.conf"
	else
		log WARN "iwd config not found at $iwd_conf, skipping config copy"
	fi

	# Enable and start iwd
	if systemctl is-enabled iwd &>/dev/null; then
		log INFO "iwd already enabled"
	else
		run sudo systemctl enable iwd
		log OK "iwd enabled"
	fi
	run sudo systemctl start iwd

	# Enable and start dhcpcd
	if systemctl is-enabled dhcpcd &>/dev/null; then
		log INFO "dhcpcd already enabled"
	else
		run sudo systemctl enable dhcpcd
		log OK "dhcpcd enabled"
	fi
	run sudo systemctl start dhcpcd

	log OK "iwd + dhcpcd services started"
	SUMMARY_STATUS[iwd]="Done"
}

iwd_summary() {
	log INFO "iwd module status: ${SUMMARY_STATUS[iwd]}"
}
