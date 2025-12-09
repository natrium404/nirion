#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$HOME/.nirion"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# ------------------------------------------------------------
# Function to check if the folder is inside the base directory
# ------------------------------------------------------------
check_folder_within_base_dir() {
	local folder="$1"
	local base_dir="$2"

	# Get absolute paths of folder and base directory
	local abs_folder
	abs_folder=$(realpath "$folder")

	local abs_base_dir
	abs_base_dir=$(realpath "$base_dir")

	# Check if the folder is within the base directory
	if [[ "$abs_folder" != "$abs_base_dir"* ]]; then
		# Define colors
		local RED='\033[0;31m'
		local GREEN='\033[0;32m'
		local YELLOW='\033[0;33m'
		local BLUE='\033[0;34m'
		local RESET='\033[0m'

		echo -e "${RED}ERROR:${RESET} The folder '$folder' is not inside '$base_dir'."
		echo -e "${YELLOW}To fix this, you need to move the parent folder and rename it.${RESET}"
		echo -e "Run the following command to ${GREEN}move and rename${RESET} the folder:"
		echo -e "    mv '${BLUE}$PARENT_DIR${RESET}' '${BLUE}$base_dir/${RESET}'"
		echo ""
		echo -e "Then, change to the new directory by running:"
		echo -e "    cd '${BLUE}$base_dir/installer${RESET}'"
		echo ""
		echo -e "${YELLOW}After you've moved the folder, you can re-run the script from the new location.${RESET}"
		echo -e "${BLUE}Thank you for using the installer!${RESET}"
		exit 1
	fi
}

# ------------------------------------------------------------
# Check if the script is in the right folder (inside $HOME/.nirion)
# ------------------------------------------------------------
check_folder_within_base_dir "$SCRIPT_DIR" "$BASE_DIR"
echo "Folder is inside the correct base directory, proceeding..."

# ------------------------------------------------------------
# Global variables
# ------------------------------------------------------------
DRY_RUN=false
FORCE_RUN=false
AUTO_YES=false

LOGFILE="$HOME/.nirion.log"
SCRIPT_DIR="$BASE_DIR/installer"
SCRIPT_DIR="$(realpath "$SCRIPT_DIR")" # Resolve symlinks just in case

# Summary tracker
declare -A SUMMARY_STATUS=(
	[packages]="Pending"
	[paru]="Pending"
	[zsh]="Pending"
	[starship]="Pending"
	[themes]="Pending"
	[fonts]="Pending"
	[symlinks]="Pending"
	[flatpak]="Pending"
	[pkglist]="Pending"
	[cleanup]="Pending"
)

# ------------------------------------------------------------
# Argument parsing
# ------------------------------------------------------------
usage() {
	cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --dry-run, -d   Run without making changes
  --force, -f     Force overwrite
  --yes, -y       Auto-confirm prompts
  --help, -h      Show this help
EOF
}

while (($#)); do
	case "$1" in
	--dry-run | -d)
		DRY_RUN=true
		shift
		;;
	--force | -f)
		FORCE_RUN=true
		shift
		;;
	--yes | -y)
		AUTO_YES=true
		shift
		;;
	--help | -h)
		usage
		exit 0
		;;
	*)
		echo "Unknown option $1"
		usage
		exit 1
		;;
	esac
done

# ------------------------------------------------------------
# Load configs
# ------------------------------------------------------------
CONFIG_DIR="$SCRIPT_DIR/config"
CONFIG_FILES=(modules.conf paths.conf packages.conf logging.conf user.conf)
for cfg in "${CONFIG_FILES[@]}"; do
	[[ -f "$CONFIG_DIR/$cfg" ]] && source "$CONFIG_DIR/$cfg"
done

# ------------------------------------------------------------
# Load libraries
# ------------------------------------------------------------
LIB_DIR="$SCRIPT_DIR/lib"
LIB_FILES=(colors.sh log.sh utils.sh checks.sh prompt.sh)

for lib in "${LIB_FILES[@]}"; do
	[[ -f "$LIB_DIR/$lib" ]] && source "$LIB_DIR/$lib"
done

# ------------------------------------------------------------
# Preflight checks
# ------------------------------------------------------------
preflight() {
	log_section "PRE-FLIGHT CHECKS"

	check_internet || {
		log ERROR "No internet connection"
		exit 1
	}
	check_required_binaries git curl pacman || exit 1
	setup_log_dir "$LOGFILE"

	if [ -d "$DOTFILES_DIR" ]; then
		log INFO "Dotfiles detected at $DOTFILES_DIR"
		if ! $FORCE_RUN && ! confirm "Overwrite existing dotfiles?"; then
			log ERROR "User aborted due to existing dotfiles"
			exit 1
		fi
	else
		log INFO "No dotfiles found, will setup later"
	fi
}

# ------------------------------------------------------------
# Load modules dynamically
# ------------------------------------------------------------
MODULE_DIR="$SCRIPT_DIR/modules"
MODULES_ORDER=(packages paru zsh starship themes fonts symlinks flatpak pkglist cleanup)

declare -A MODULE_FUNCS
load_modules() {
	for mod in "${MODULES_ORDER[@]}"; do
		mod_file="$MODULE_DIR/$mod.sh"
		if [[ -f "$mod_file" ]]; then
			source "$mod_file"
			MODULE_FUNCS["$mod"]="$mod"
		else
			log WARN "Module missing: $mod_file"
			SUMMARY_STATUS[$mod]="Missing"
		fi
	done
}

# ------------------------------------------------------------
# Execute modules
# ------------------------------------------------------------
run_modules() {
	for mod in "${MODULES_ORDER[@]}"; do
		if [[ "${MODULE_FUNCS[$mod]+_}" ]]; then
			log_section "MODULE: $mod"
			"$mod"_init
			if "$mod"_validate; then
				"$mod"_run
			else
				log WARN "Skipping $mod (disabled in config)"
				SUMMARY_STATUS[$mod]="Skipped"
			fi
			"$mod"_summary
		fi
	done
}

# ------------------------------------------------------------
# Print summary
# ------------------------------------------------------------
print_summary() {
	log_section "INSTALLATION SUMMARY"
	for key in "${!SUMMARY_STATUS[@]}"; do
		printf "%-12s : %s\n" "$key" "${SUMMARY_STATUS[$key]}"
	done
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------
main() {
	log_section "STARTING INSTALLER"

	preflight
	load_modules
	run_modules
	print_summary

	log_section "INSTALLATION COMPLETE 🎉"
	log INFO "Dotfiles repo: $DOTFILES_DIR"
	log INFO "Log file: $LOGFILE"
	log INFO "To switch shell, run: chsh -s $(which zsh)"
}

main "$@"
