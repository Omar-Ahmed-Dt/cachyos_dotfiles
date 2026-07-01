#!/bin/bash
#!/usr/bin/env bash
set -euo pipefail

NOTE_DIR="$HOME/.local/share/dmnote"
mkdir -p "$(dirname "$NOTE_DIR")"
touch "$NOTE_DIR"

choice=$(printf 'Copy note\nNew note\nDelete note' | fuzzel -d -p "Notes: ")
[ -z "$choice" ] && exit 0

case "$choice" in
  'Copy note')
    note_pick=$(fuzzel -d -p "Copy: " < "$NOTE_DIR")
    [ -n "$note_pick" ] && echo "$note_pick" | wl-copy && notify-send -u normal "Note copied" "$note_pick"
    ;;
  'New note')
    note_new=$(echo "" | fuzzel -d -p "New note: ")
    [ -n "$note_new" ] && ! grep -qFx "$note_new" "$NOTE_DIR" \
      && echo "$note_new" >> "$NOTE_DIR" && notify-send -u normal "Note created" "$note_new"
    ;;
  'Delete note')
    note_del=$(fuzzel -d -p "Delete: " < "$NOTE_DIR")
    if [ -n "$note_del" ]; then
      grep -vFx "$note_del" "$NOTE_DIR" > /tmp/dmnote || true
      cp -f /tmp/dmnote "$NOTE_DIR"
      notify-send -u normal "Note deleted" "$note_del"
    fi
    ;;
  *)
    exit 0
    ;;
esac
