#!/usr/bin/env bash

flatpak_init() {
	log STEP "Initializing Flatpak module"
}

flatpak_validate() {
	[ "$ENABLE_FLATPAK" = true ]
}

flatpak_run() {
	run sudo flatpak override --filesystem=xdg-config/gtk-3.0
	run sudo flatpak override --filesystem=xdg-config/gtk-4.0
	log OK "Flatpak GTK overrides applied"
	SUMMARY_STATUS[flatpak]="Done"
}

flatpak_summary() {
	log INFO "Flatpak module status: ${SUMMARY_STATUS[flatpak]}"
}
