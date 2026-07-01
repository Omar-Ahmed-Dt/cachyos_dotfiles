#!/bin/bash

# selection=$(cliphist list | sed 's/^\S*\t//' | fuzzel -d -p "Clipboard: ")
# [ -z "$selection" ] && exit 0
# cliphist list | grep -F "$selection" | head -1 | cliphist decode | wl-copy

cliphist list | fuzzel --placeholder "Search Clipboard... " --dmenu --with-nth 2 | cliphist decode | wl-copy

