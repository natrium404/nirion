#!/usr/bin/env bash

paru_init() {
	log STEP "Initializing Paru (AUR helper)"
}

paru_validate() {
	[ "$ENABLE_PARU" = true ]
}

paru_run() {
	if ! command -v paru &>/dev/null; then
		log INFO "Installing paru"
		run git clone https://aur.archlinux.org/paru.git "$DOWNLOADS_DIR/paru"
		run "cd $DOWNLOADS_DIR/paru && makepkg -si --noconfirm"
		run rm -rf "$DOWNLOADS_DIR/paru"
		log OK "Paru installed"
	else
		log INFO "Paru already installed"
	fi
	SUMMARY_STATUS[paru]="Done"
}

paru_summary() {
	log INFO "Paru module status: ${SUMMARY_STATUS[paru]}"
}
