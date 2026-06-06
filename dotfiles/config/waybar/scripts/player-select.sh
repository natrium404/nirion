#!/bin/bash
# Rofi-based MPRIS player selector. Saves selection to preferred-player file.
# All playerctl commands then auto-target this player via the wrapper.

PREF_FILE="${XDG_RUNTIME_DIR:-/tmp}/playerctl-preferred-player"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/playerctl-current-player"
CURRENT=$(cat "$PREF_FILE" 2>/dev/null)
[ -z "$CURRENT" ] && CURRENT=$(cat "$STATE_FILE" 2>/dev/null)

# Build rofi entries: "player [status]" with ✓ for current selection
entries=""
for player in $(/usr/bin/playerctl -l 2>/dev/null); do
  status=$(/usr/bin/playerctl --player="$player" status 2>/dev/null)
  mark=""
  [[ "$player" == "$CURRENT" ]] && mark=" ✓"
  # Use newline-separated entries with a custom delimiter
  entries+="$player [$status]$mark"$'\n'
done

# Add a "No preference (auto)" option
entries+="Auto (auto-detect)"

if [[ -z "$entries" ]]; then
  notify-send "Player Select" "No MPRIS players found"
  exit 0
fi

# Use rofi to pick
CHOICE=$(echo "$entries" | rofi -dmenu -p "Select Player" -theme-str '
window { width: 300px; }
listview { lines: 10; }
')

[[ -z "$CHOICE" ]] && exit 0

# Extract player name (before the first space)
PLAYER=$(echo "$CHOICE" | awk '{print $1}')

if [[ "$PLAYER" == "Auto" ]] || [[ "$PLAYER" == "Auto"* ]]; then
  rm -f "$PREF_FILE"
  notify-send "Player Select" "Auto-detect (no preference)" -i media-playback-playing
else
  echo "$PLAYER" > "$PREF_FILE"
  notify-send "Player Select" "Selected: $PLAYER" -i media-playback-playing
fi
