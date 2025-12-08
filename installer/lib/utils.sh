#!/usr/bin/env bash
# Utility functions

run() {
	local cmd="$*"
	if $DRY_RUN; then
		log INFO "[DRY RUN] $cmd"
	else
		eval "$cmd" 2>&1 | strip_colors >>"$LOGFILE"
	fi
}

run_silent() {
	local cmd="$*"
	if $DRY_RUN; then
		log INFO "[DRY RUN] $cmd"
	else
		eval "$cmd"
	fi
}

setup_log_dir() {
	local logpath="$1"
	mkdir -p "$(dirname "$logpath")"
	touch "$logpath"
}

atomic_symlink() {
	local src="$1"
	local dest="$2"
	local backfile
	if ([ -e "$dest" ] || [ -L "$dest" ]); then
		if [ $FORCE_RUN ]; then
			rm -rf "$dest"
		else
			mv "$dest" "${dest}.backup.$(date +%s)"
		fi
	fi
	ln -s "$src" "$dest"

}
