#!/usr/bin/env bash

DIR="$HOME/youtube-dl"
mkdir -p "$DIR"

URL="$(wl-paste)"

# Ask for video name
# NAME=$(rofi -dmenu -p "Video name (optional):")
NAME=$(echo "" | fuzzel -d -p "Track name (optional):")

if [ -z "$NAME" ]; then
    OUTPUT="$DIR/%(title)s.%(ext)s"
else
    OUTPUT="$DIR/$NAME.%(ext)s"
fi

kitty -e yt-dlp \
-f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" \
--merge-output-format mp4 \
"$URL" -o "$OUTPUT" && notify-send -i ~/logo/download.png "Video download completed"
