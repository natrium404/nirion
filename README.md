# Caniri
> Modular, safe, and idempotent config installer for CachyOS user-space setup.
**NOTE: THIS ONLY WORKS IN CACHYOS NIRI WM**

---

## Table of Contents

- [Installation](#installation)  
- [Configuration](#configuration)  
- [Modules](#modules)  
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

All configuration is centralized under `config/`:

| File            | Purpose                                  |
| --------------- | ---------------------------------------- |
| `modules.conf`  | Enable or disable specific modules       |
| `paths.conf`    | Paths for dotfiles, icons, fonts, themes |
| `packages.conf` | Lists of Pacman and AUR packages         |
| `logging.conf`  | Verbosity, color options                 |
| `user.conf`     | Username-specific or custom settings     |

Modify these files to adjust behavior without touching the installer code.

---

## Modules

| Module        | Purpose                            |
| ------------- | ---------------------------------- |
| `dotfiles.sh` | Setup or clone dotfiles            |
| `packages.sh` | Install Pacman packages            |
| `paru.sh`     | Install AUR helper if needed       |
| `zsh.sh`      | Install Oh-My-Zsh and plugins      |
| `starship.sh` | Install Starship prompt            |
| `themes.sh`   | Install GTK/Icon themes            |
| `fonts.sh`    | Install or copy fonts              |
| `symlinks.sh` | Create atomic symlinks for configs |
| `flatpak.sh`  | Apply Flatpak GTK overrides        |
| `cleanup.sh`  | Optional cleanup tasks             |

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