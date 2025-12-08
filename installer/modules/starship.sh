#!/usr/bin/env bash

starship_init() {
	log STEP "Initializing Starship module"
}

starship_validate() {
	[ "$ENABLE_STARSHIP" = true ]
}

starship_run() {
	if ! command -v starship &>/dev/null; then
		mkdir -p "$HOME/.local/bin"
		local installer=$(mktemp)
		run_silent curl -fsSLo "$installer" https://starship.rs/install.sh
		run_silent sh "$installer" --yes -b "$HOME/.local/bin"
		run rm "$installer"
		log OK "Starship installed"
	else
		log INFO "Starship already installed"
	fi
	SUMMARY_STATUS[starship]="Done"
}

starship_summary() {
	log INFO "Starship module status: ${SUMMARY_STATUS[starship]}"
}
