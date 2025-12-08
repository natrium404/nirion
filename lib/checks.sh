#!/usr/bin/env bash
# Preflight validation functions

check_internet() {
	if ping -c1 1.1.1.1 &>/dev/null; then
		log OK "Internet connection detected"
		return 0
	else
		log ERROR "No internet connection"
		return 1
	fi
}

check_required_binaries() {
	local missing=0
	for bin in "$@"; do
		if ! command -v "$bin" &>/dev/null; then
			log ERROR "Required binary missing: $bin"
			missing=1
		fi
	done
	return $missing
}
