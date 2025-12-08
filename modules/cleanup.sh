#!/usr/bin/env bash

cleanup_init() {
	log STEP "Initializing Cleanup module"
}

cleanup_validate() {
	[ "$ENABLE_CLEANUP" = true ]
}

cleanup_run() {
	run rm -rf "$DOWNLOADS_DIR/paru" "$DOWNLOADS_DIR/Colloid-icon-theme" "$DOWNLOADS_DIR/Colloid-gtk-theme"
	log OK "Temporary installer directories cleaned"
	SUMMARY_STATUS[cleanup]="Done"
}

cleanup_summary() {
	log INFO "Cleanup module status: ${SUMMARY_STATUS[cleanup]}"
}
