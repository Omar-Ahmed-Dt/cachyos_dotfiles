#!/bin/bash
# Clipboard history picker. The first entry clears the whole history.

WIPE=$'wipe\t  Clear clipboard history'

choice=$({ printf '%s\n' "$WIPE"; cliphist list; } |
    fuzzel --placeholder "Search Clipboard... " --dmenu --with-nth 2)
[ -z "$choice" ] && exit 0

if [ "$choice" = "$WIPE" ]; then
    [ "$(printf 'Yes' | fuzzel -d -i -p 'Really clear history? ')" = "Yes" ] || exit 0
    cliphist wipe && notify-send -t 1500 "Clipboard" "History cleared"
    exit 0
fi

printf '%s\n' "$choice" | cliphist decode | wl-copy
