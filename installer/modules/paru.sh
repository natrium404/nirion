#!/usr/bin/env bash

paru_init() {
	log STEP "Initializing Paru (AUR helper)"
}

paru_validate() {
	[ "$ENABLE_PARU" = true ]
}

paru_run() {
	if ! command -v paru &>/dev/null; then
		log INFO "Paru not found → installing"
		run git clone https://aur.archlinux.org/paru.git "$DOWNLOADS_DIR/paru"
		run "cd $DOWNLOADS_DIR/paru && makepkg -si --noconfirm"
		run rm -rf "$DOWNLOADS_DIR/paru"
		log OK "Paru installed"
	else
		log INFO "Paru already installed"
	fi

	# Install AUR packages
	if [ "${#AUR_PACKAGES[@]}" -gt 0 ]; then
		log INFO "Installing AUR packages via Paru"
		for pkg in "${AUR_PACKAGES[@]}"; do
			if ! paru -Qi "$pkg" &>/dev/null; then
				run paru -S --noconfirm "$pkg"
				log OK "Installed AUR package: $pkg"
			else
				log INFO "AUR package already installed: $pkg"
			fi
		done
	else
		log INFO "No AUR packages to install"
	fi

	SUMMARY_STATUS[paru]="Done"
}

paru_summary() {
	log INFO "Paru module status: ${SUMMARY_STATUS[paru]}"
}
