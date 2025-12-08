#!/usr/bin/env bash

dotfiles_init() {
	log STEP "Initializing dotfiles module"
}

dotfiles_validate() {
	[ "$ENABLE_DOTFILES" = true ]
}

dotfiles_run() {
	if [ -d "$DOTFILES_DIR" ]; then
		log INFO "Dotfiles exist at $DOTFILES_DIR"
		if ! $FORCE_RUN; then
			log INFO "Skipping dotfiles clone"
			SUMMARY_STATUS[dotfiles]="Skipped"
			return
		fi
	fi

	if [ -d "$SCRIPT_DIR" ]; then
		run mkdir -p "$DOTFILES_DIR"
		run cp -r "$SCRIPT_DIR"/* "$DOTFILES_DIR"/
		log OK "Dotfiles copied to $DOTFILES_DIR"
	else
		log ERROR "No dotfiles directory available"
		SUMMARY_STATUS[dotfiles]="Failed"
		return
	fi
	SUMMARY_STATUS[dotfiles]="Done"
}

dotfiles_summary() {
	log INFO "Dotfiles status: ${SUMMARY_STATUS[dotfiles]}"
}
