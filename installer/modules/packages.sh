#!/usr/bin/env bash

packages_init() {
	log STEP "Initializing packages module"
}

packages_validate() {
	[ "$ENABLE_PACKAGES" = true ]
}

packages_run() {
	log INFO "Updating system"
	run sudo pacman -Syu --noconfirm

	for pkg in "${PACMAN_PACKAGES[@]}"; do
		if ! pacman -Qi "$pkg" &>/dev/null; then
			run sudo pacman -S --noconfirm "$pkg"
			log OK "Installed $pkg"
		else
			log INFO "$pkg already installed"
		fi
	done

	SUMMARY_STATUS[packages]="Done"
}

packages_summary() {
	log INFO "Packages module status: ${SUMMARY_STATUS[packages]}"
}
