#!/bin/sh
# Toggle a drop-down terminal kept in the scratchpad; create it on first use.
if swaymsg -t get_tree | grep -q '"app_id": "dropterm"'; then
    swaymsg '[app_id="dropterm"] scratchpad show' >/dev/null
else
    exec footclient --app-id=dropterm
fi
