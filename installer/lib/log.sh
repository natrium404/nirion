#!/usr/bin/env bash
# Logging functions

strip_colors() {
	sed -r "s/\x1B\[[0-9;]*m//g; s/\x1B\[K//g"
}

log() {
	local level="$1"
	shift
	local msg="$*"
	local color symbol
	local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

	case "$level" in
	INFO)
		color="$CYAN"
		symbol="$ICON_INFO"
		;;
	OK)
		color="$GREEN"
		symbol="$ICON_OK"
		;;
	WARN)
		color="$YELLOW"
		symbol="$ICON_WARN"
		;;
	ERROR)
		color="$RED"
		symbol="$ICON_ERROR"
		;;
	STEP)
		color="$MAGENTA"
		symbol="$ICON_STEP"
		;;
	SECTION)
		color="$BLUE"
		symbol="$ICON_SECTION"
		;;
	*)
		color="$WHITE"
		symbol="-"
		;;
	esac

	echo -e "${color}${symbol} ${msg}${RESET}"
	echo "[${timestamp}] [$level] $msg" | strip_colors >>"$LOGFILE"
}

log_section() {
	echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
	log SECTION " $1"
	echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}
