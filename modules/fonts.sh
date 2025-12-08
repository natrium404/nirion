#!/usr/bin/env bash

fonts_init() {
	log STEP "Initializing Fonts module"
}

fonts_validate() {
	[ "$ENABLE_FONTS" = true ]
}

fonts_run() {
	if [ -d "$DOTFILES_DIR/.fonts" ]; then
		run mkdir -p "$FONTS_DIR"
		run cp -r "$DOTFILES_DIR/.fonts/"* "$FONTS_DIR/"
		log OK "Fonts copied to $FONTS_DIR"
		SUMMARY_STATUS[fonts]="Done"
	else
		log WARN "No fonts folder in dotfiles"
		SUMMARY_STATUS[fonts]="Skipped"
	fi
}

fonts_summary() {
	log INFO "Fonts module status: ${SUMMARY_STATUS[fonts]}"
}
