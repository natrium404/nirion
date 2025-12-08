#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Global variables
# ------------------------------------------------------------
DRY_RUN=false
FORCE_RUN=false
AUTO_YES=false

LOGFILE="$HOME/nirion.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(realpath "$SCRIPT_DIR")" # resolve symlinks just in case

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
MODULES_ORDER=(packages paru zsh starship themes fonts symlinks flatpak cleanup)

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
