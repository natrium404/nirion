#!/usr/bin/env bash

cleanup_init() {
	log STEP "Initializing Cleanup module"
}

cleanup_validate() {
	[ "$ENABLE_CLEANUP" = true ]
}

cleanup_run() {
	log STEP "Cleanup temporary installer directories"

	local DIRS=("$DOWNLOADS_DIR/paru" "$DOWNLOADS_DIR/Colloid-icon-theme" "$DOWNLOADS_DIR/Colloid-gtk-theme")

	# Ask user before deleting
	if confirm "Do you want to delete temporary installer directories?"; then
		for dir in "${DIRS[@]}"; do
			if [ -d "$dir" ]; then
				run rm -rf "$dir"
				log OK "Deleted $dir"
			else
				log INFO "$dir does not exist, skipping"
			fi
		done
		SUMMARY_STATUS[cleanup]="Done"
	else
		log INFO "Cleanup skipped by user"
		SUMMARY_STATUS[cleanup]="Skipped"
	fi
}

cleanup_summary() {
	log INFO "Cleanup module status: ${SUMMARY_STATUS[cleanup]}"
}
