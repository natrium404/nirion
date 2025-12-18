#!/usr/bin/env bash

themes_init() {
	log STEP "Initializing Themes module"
}

themes_validate() {
	[ "$ENABLE_THEMES" = true ]
}

themes_run() {
	if ! confirm "Do you want to install themes and icons?"; then
		log INFO "Theme installation skipped by user"
		SUMMARY_STATUS[cleanup]="Skipped"
	else
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

			# Install Colloid GTK themes if not already installed
			if ! compgen -G "$HOME/.themes/Colloid-*" >/dev/null; then
				log STEP "Installing Colloid GTK themes..."
				run_silent "cd $DOWNLOADS_DIR/Colloid-gtk-theme && ./install.sh -t all --tweaks black --tweaks rimless -l"
			else
				log INFO "Colloid GTK themes already installed, skipping."
			fi

			# Install Colloid icons if not already installed
			if ! compgen -G "$HOME/.icons/Colloid-*" >/dev/null; then
				log STEP "Installing Colloid icon theme..."
				run_silent "cd $DOWNLOADS_DIR/Colloid-icon-theme && ./install.sh -s default -t default"
			else
				log INFO "Colloid icons already installed, skipping."
			fi

		fi

		SUMMARY_STATUS[themes]="Done"
	fi
}

themes_summary() {
	log INFO "Themes module status: ${SUMMARY_STATUS[themes]}"
}
