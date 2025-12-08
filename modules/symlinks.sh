#!/usr/bin/env bash

symlinks_init() {
	log STEP "Initializing Symlinks module"
}

symlinks_validate() {
	[ "$ENABLE_SYMLINKS" = true ]
}

symlinks_run() {
	run mkdir -p "$USER_CONFIG_DIR"

	local CONFIGS=(btop fontconfig geany gtk-3.0 gtk-4.0 kitty mpv niri qt5ct qt6ct rofi swappy waybar Kvantum)

	for folder in "${CONFIGS[@]}"; do
		local SRC="$DOTFILES_DIR/config/$folder"
		local DEST="$USER_CONFIG_DIR/$folder"
		if [ -d "$SRC" ]; then
			atomic_symlink "$SRC" "$DEST"
			log OK "Linked $folder"
		else
			log WARN "$folder missing → skipped"
		fi
	done

	local FILES=(.zshrc .zshalias starship.toml)
	for file in "${FILES[@]}"; do
		local SRC="$DOTFILES_DIR/$file"
		local DEST="$HOME/$file"
		[ -f "$SRC" ] && atomic_symlink "$SRC" "$DEST"
	done

	if [ -d "$DOTFILES_DIR/config/icons" ]; then
		atomic_symlink "$DOTFILES_DIR/config/icons" "$ICONS_TARGET"
		log OK "Icons linked"
	fi

	SUMMARY_STATUS[symlinks]="Done"
}

symlinks_summary() {
	log INFO "Symlinks module status: ${SUMMARY_STATUS[symlinks]}"
}
