#!/bin/bash

cleanup() {
  echo ""
  exit 0
}

trap cleanup SIGINT SIGTERM

playerctl metadata --follow --format '{{status}};{{artist}};{{title}};{{playerName}};{{mpris:trackid}};{{album}}' 2>/dev/null | while read -r line; do

  status=$(echo "$line" | cut -d ';' -f 1)
  artist=$(echo "$line" | cut -d ';' -f 2)
  title=$(echo "$line" | cut -d ';' -f 3)
  name=$(echo "$line" | cut -d ';' -f 4)
  trackid=$(echo "$line" | cut -d ';' -f 5)
  album=$(echo "$line" | cut -d ';' -f 6)

  if [[ "$status" == "Stopped" ]] || [[ -z "$title" ]]; then
    echo '{"text": "", "class": "hidden"}'
    continue
  fi

  if [[ "$name" == "spotify" && "$trackid" == *":ad:"* ]]; then
    bar_text="AD PLAYING"
  elif [[ -n "$artist" ]]; then
    bar_text="$title - $artist"
  else
    bar_text="$title"
  fi

  icon=" "
  [[ "$status" == "Paused" ]] && icon=" "

  tooltip="Title: $title\nArtist: ${artist:-Unknown}\nAlbum: ${album:-N/A}\nPlayer: ${name^}\nStatus: $status"

  final_bar=$(echo "$icon  $bar_text" | sed 's/"/\\"/g')
  final_tooltip=$(echo "$tooltip" | sed 's/"/\\"/g')

  printf '{"text": "%s", "tooltip": "%s", "class": "%s", "alt": "%s"}\n' "$final_bar" "$final_tooltip" "$name" "$status"

done
