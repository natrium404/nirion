#!/usr/bin/env bash

themes_init() {
	log STEP "Initializing Themes module"
}

themes_validate() {
	[ "$ENABLE_THEMES" = true ]
}

themes_run() {
	run mkdir -p "$DOWNLOADS_DIR"

	if [ ! -d "$DOWNLOADS_DIR/Colloid-icon-theme" ]; then
		run git clone https://github.com/vinceliuice/Colloid-icon-theme.git "$DOWNLOADS_DIR/Colloid-icon-theme"
		run_silent "cd $DOWNLOADS_DIR/Colloid-icon-theme && ./install.sh -s default -t default"
		log OK "Colloid icon theme installed"
	else
		log INFO "Colloid icon theme already exists"
	fi

	if [ ! -d "$DOWNLOADS_DIR/Colloid-gtk-theme" ]; then
		run git clone https://github.com/vinceliuice/Colloid-gtk-theme.git "$DOWNLOADS_DIR/Colloid-gtk-theme"
		run_silent "cd $DOWNLOADS_DIR/Colloid-gtk-theme && ./install.sh -t all --tweaks black --tweaks rimless -l"
		log OK "Colloid GTK theme installed"
	else
		log INFO "Colloid GTK theme already exists"
	fi

	SUMMARY_STATUS[themes]="Done"
}

themes_summary() {
	log INFO "Themes module status: ${SUMMARY_STATUS[themes]}"
}
