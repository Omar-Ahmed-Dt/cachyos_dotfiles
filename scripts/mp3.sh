#!/usr/bin/env bash

DIR="$HOME/youtube-dl"
mkdir -p "$DIR"

URL="$(wl-paste)"

# Ask for track name using rofi
# NAME=$(rofi -dmenu -p "Track name (optional):")
NAME=$(echo "" | fuzzel -d -p "Track name (optional):")

if [ -z "$NAME" ]; then
    OUTPUT="$DIR/%(title)s.%(ext)s"
else
    OUTPUT="$DIR/$NAME.%(ext)s"
fi

kitty -e yt-dlp --extract-audio --audio-format mp3 "$URL" -o "$OUTPUT" && notify-send -i ~/logo/download.png "Download completed"
