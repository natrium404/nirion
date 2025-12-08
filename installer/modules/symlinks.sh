#!/usr/bin/env bash

# ------------------------------------------------------------
# Symlinks Module
# ------------------------------------------------------------

symlinks_init() {
	log STEP "Initializing Symlinks module"
}

symlinks_validate() {
	[ "$ENABLE_SYMLINKS" = true ]
}

# ------------------------------------------------------------
# Generic dynamic symlink function
# ------------------------------------------------------------
create_symlink() {
	local src="$1"
	local dest="$2"

	if [ -d "$src" ] || [ -f "$src" ]; then
		run mkdir -p "$(dirname "$dest")"
		atomic_symlink "$src" "$dest"
		if [ -d "$src" ]; then
			log OK "Linked directory: $dest"
		else
			log OK "Linked file: $dest"
		fi
	else
		log WARN "Source missing, skipping: $src"
	fi
}

# ------------------------------------------------------------
# List all items to symlink (relative to DOTFILES_DIR)
# Format: "relative_src_path:destination_path"
# ------------------------------------------------------------
LINK_ITEMS=(
	# Config directories
	"config/btop:$USER_CONFIG_DIR/btop"
	"config/fontconfig:$USER_CONFIG_DIR/fontconfig"
	"config/geany:$USER_CONFIG_DIR/geany"
	"config/gtk-3.0:$USER_CONFIG_DIR/gtk-3.0"
	"config/gtk-4.0:$USER_CONFIG_DIR/gtk-4.0"
	"config/kitty:$USER_CONFIG_DIR/kitty"
	"config/mpv:$USER_CONFIG_DIR/mpv"
	"config/niri:$USER_CONFIG_DIR/niri"
	"config/qt5ct:$USER_CONFIG_DIR/qt5ct"
	"config/qt6ct:$USER_CONFIG_DIR/qt6ct"
	"config/rofi:$USER_CONFIG_DIR/rofi"
	"config/swappy:$USER_CONFIG_DIR/swappy"
	"config/waybar:$USER_CONFIG_DIR/waybar"
	"config/Kvantum:$USER_CONFIG_DIR/Kvantum"
	"config/starship.toml:$USER_CONFIG_DIR/starship.toml"

	".zshrc:$HOME/.zshrc"
	".zshalias:$HOME/.zshalias"

	# Icons
	"icons:$HOME/.icons"
)

# ------------------------------------------------------------
# Run module
# ------------------------------------------------------------
symlinks_run() {
	for item in "${LINK_ITEMS[@]}"; do
		IFS=":" read -r src dest <<<"$item"
		create_symlink "$DOTFILES_DIR/$src" "$dest"
	done

	SUMMARY_STATUS[symlinks]="Done"
}

# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------
symlinks_summary() {
	log INFO "Symlinks module status: ${SUMMARY_STATUS[symlinks]}"
}
