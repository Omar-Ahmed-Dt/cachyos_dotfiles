#!/usr/bin/env bash

# OPT=$(echo -e "Voice\nVideo" | rofi -dmenu -i -p "Choose action:")
OPT=$(echo -e "Voice\nVideo" | fuzzel -d -i -p "Choose action: ")

SCRIPTS="$HOME/scripts"

case "$OPT" in
    Voice) "$SCRIPTS/mp3.sh" ;;
    Video) "$SCRIPTS/mp4.sh" ;;
    *) ;;
esac
