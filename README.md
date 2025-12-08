# Nirion
> Modular, safe, and idempotent config installer for CachyOS user-space setup.
**NOTE: THIS ONLY WORKS IN CACHYOS NIRI WM** (cuz i haven't tested it anywhere else and i am dumb)

---

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Modules](#modules)
- [Symlinks](#symlinks)
- [Fonts](#fonts)
- [Usage](#usage)
- [Logging](#logging)
- [Project Structure](#project-structure)

---

## Installation

Clone the repository:

```bash
git clone https://github.com/your-username/your-repo.git ~/niri-setup
cd ~/niri-setup/installer
````

Run the installer:

```bash
# Interactive mode
./installer.sh

# Dry-run mode (preview changes)
./installer.sh --dry-run

# Automated mode (no prompts)
./installer.sh --yes --force
```

---

## Configuration

All installer-specific configuration is centralized under `config/`:

| File            | Purpose                                  |
| --------------- | ---------------------------------------- |
| `modules.conf`  | Enable or disable specific modules       |
| `paths.conf`    | Paths for dotfiles, icons, fonts, themes |
| `packages.conf` | Lists of Pacman and AUR packages         |
| `logging.conf`  | Verbosity, color options                 |
| `user.conf`     | Username-specific or custom settings     |

Modify these files to adjust the installer’s behavior **without touching the installer code**.

> ⚠️ Note: This configuration is **for the installer only**, not for the system.  
> If you add a new config file, make sure to include it in the `CONFIG_FILES` array in `installer.sh`:
```bash
CONFIG_FILES=(... custom.conf)
````

---

## Modules

The installer is modular. Each module resides in `installer/modules/`:

| Module        | Purpose                            |
| ------------- | ---------------------------------- |
| `packages.sh` | Install Pacman packages            |
| `paru.sh`     | Install AUR helper if needed       |
| `zsh.sh`      | Install Oh-My-Zsh and plugins      |
| `starship.sh` | Install Starship prompt            |
| `themes.sh`   | Install GTK/Icon themes            |
| `fonts.sh`    | Copy or install fonts              |
| `symlinks.sh` | Create atomic symlinks for configs |
| `flatpak.sh`  | Apply Flatpak GTK overrides        |
| `cleanup.sh`  | Optional cleanup tasks             |

> ⚠️ Note: These modules are **for the installer only**, not for the system.  
> If you add a new module, include it in the `MODULES_ORDER` array in `installer.sh`:
```bash
MODULES_ORDER=(packages paru zsh ... custom)
````

> ⚠️ Note:
>
> 1. The order **matters** - modules run in this sequence.
> 2. Only use the **filename without the `.sh` extension** in the array.


### Module Template

Each module must define three functions:

```bash
#!/usr/bin/env bash

<module>_init() {
    # Initial heading for the module
    # This will be logged both in the log file and the terminal
    log STEP "Initializing <MODULE_NAME> module"
}

<module>_validate() {
    # Determines if the module is enabled in modules.conf
    # Example for a "cleanup" module:
    #   In config/modules.conf:
    #       ENABLE_CLEANUP=true   # or false to disable
    #
    # This function should return true if the module should run, false otherwise

    [ "$ENABLE_CLEANUP" = true ]
}

<module>_run() {
    # Main logic of the module goes here
    # For example, cleanup, installation, or symlinking tasks
}

<module>_summary() {
    # Add module status to the installer summary
    # Example: log INFO "<MODULE_NAME> module status: ${SUMMARY_STATUS[<module>]}"
}
```

> Change the `<module>` with the module name
> Module name must be same as the filename
> ⚠️ All modules **must follow this template** to integrate correctly with the installer framework.
> The `_init` function logs the start, `_validate` controls whether the module runs, `_run` performs the main tasks, and `_summary` logs the final status.

---

## Symlinks

This module creates all the necessary symlinks for `.config` directories and files in `$HOME` (like `.zshrc`).  

To add a new config to `.config`, simply place the folder or file in the `dotfiles/config/` directory. Then, open `modules/symlinks.sh` and edit the `LINK_ITEMS` array:

```sh
LINK_ITEMS=(
    "relative_src_path:destination_path"
    # NOTE: relative_src_path is relative to $DOTFILES_DIR
    # Example:
    # "config/kitty:$USER_CONFIG_DIR/kitty"
    # "config/starship.toml:$USER_CONFIG_DIR/starship.toml"
)
```

---

## Fonts

The **fonts** directory will be copied to `$HOME`, along with all its content. If you want to add any fonts, please copy them here as well as to `$HOME/.fonts`.

**NOTE**
- Fonts added to this directory will not be included in the system.
- To ensure fonts are accessible, add them to your **home directory** or the specified directory.
- ⚠️ Keeping unnecessary fonts in the **fonts** folder can increase the repository size without any benefit.
- The **fonts** directory is copied, not symlinked, so synchronization will not work.

---

## Packages

To install additional software, you can edit the `config/packages.conf` file.  
- Add packages to `PACMAN_PACKAGES` to install via `pacman`.  
- Add packages to `AUR_PACKAGES` to install via an AUR helper like `paru`.  

During setup, the installer will automatically install all listed packages.

---

## Usage

Command-line flags:

| Flag              | Description                       |
| ----------------- | --------------------------------- |
| `--dry-run`, `-d` | Preview changes without executing |
| `--force`, `-f`   | Force overwrite of existing files |
| `--yes`, `-y`     | Auto-confirm all prompts          |
| `--help`, `-h`    | Show help message                 |

Examples:

```bash
./installer.sh -d        # Dry-run mode
./installer.sh -fy       # Force + auto-yes
./installer.sh           # Interactive mode
```

---

## Logging

* All actions are logged to `~/niri_setup.log`
* Logs include **timestamps** and are **color-stripped**
* Summary printed at the end of the installer shows **installed, skipped, or failed** modules

---

## Project Structure

```
niri-setup/
├── installer/
│   ├── installer.sh
│   ├── format.sh
│   ├── lint.sh
│   ├── modules/
│   ├── lib/
│   └── config/
├── dotfiles/
├── LICENSE
└── README.md
```

---

> ⚠️ **Caution:** This installer modifies user-space only. No kernel tweaks, systemd units, or destructive OS-level changes.
