#!/usr/bin/env bash

zsh_init() {
	log STEP "Initializing Zsh module"
}

zsh_validate() {
	[ "$ENABLE_ZSH" = true ]
}

zsh_run() {
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		run_silent sh -c '"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
		log OK "Oh My Zsh installed"
	else
		log INFO "Oh My Zsh already exists"
	fi

	ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

	install_plugin() {
		local name="$1" repo="$2"
		if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
			run git clone "$repo" "$ZSH_CUSTOM/plugins/$name"
			log OK "Plugin installed: $name"
		else
			log INFO "Plugin exists: $name"
		fi
	}

	install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
	install_plugin zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search
	install_plugin fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting.git

	SUMMARY_STATUS[zsh]="Done"
}

zsh_summary() {
	log INFO "Zsh module status: ${SUMMARY_STATUS[zsh]}"
}
