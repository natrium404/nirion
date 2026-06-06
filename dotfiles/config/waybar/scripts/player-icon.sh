#!/bin/bash
# Waybar module: shows the active player icon. Click to open player selector.
# Uses --follow so it updates instantly when player changes.

cleanup() {
  echo ""
  exit 0
}

trap cleanup SIGINT SIGTERM

PREF_FILE="${XDG_RUNTIME_DIR:-/tmp}/playerctl-preferred-player"

# Map player name to Nerd Font icon
player_icon() {
  case "$1" in
    spotify)          echo ""  ;;
    chromium*|chrome*) echo ""  ;;
    firefox)          echo ""  ;;
    vlc)              echo "辶"  ;;
    mpv|celluloid)    echo ""  ;;
    kdeconnect*)      echo ""  ;;
    *)                echo ""  ;;
  esac
}

playerctl metadata --follow --format '{{playerName}}' 2>/dev/null | while read -r player; do
  if [[ -z "$player" ]]; then
    echo '{"text": "", "class": "hidden"}'
    continue
  fi

  icon=$(player_icon "$player")
  pref=$(cat "$PREF_FILE" 2>/dev/null)
  tooltip="$player"

  if [[ -n "$pref" ]]; then
    if [[ "$player" = "$pref" ]]; then
      tooltip=" $player"
    fi
  fi

  printf '{"text": "%s", "tooltip": "%s", "class": "%s", "alt": "%s"}\n' "$icon" "$tooltip" "visible" "$player"
done
