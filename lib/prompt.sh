#!/usr/bin/env bash
# User prompt helpers

confirm() {
	local prompt="$1"
	if $AUTO_YES; then
		return 0
	fi
	read -rp "$(echo -e "${YELLOW}?${RESET} $prompt (y/N): ")" -n 1 -r reply
	echo
	[[ "$reply" =~ ^[Yy]$ ]]
}
