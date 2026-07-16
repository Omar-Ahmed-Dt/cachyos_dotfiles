##!/usr/bin/env bash

set -euo pipefail

mime="$(wl-paste --list-types | grep -m1 '^image/' || true)"

if [[ -z "$mime" ]]; then
    notify-send "Yazi" "Clipboard does not contain an image"
    exit 1
fi

case "$mime" in
    image/png)  ext="png" ;;
    image/jpeg) ext="jpg" ;;
    image/webp) ext="webp" ;;
    image/gif)  ext="gif" ;;
    image/bmp)  ext="bmp" ;;
    image/tiff) ext="tiff" ;;
    *)          ext="${mime#image/}" ;;
esac

filename="clipboard-$(date +%Y%m%d-%H%M%S).${ext}"

wl-paste --type "$mime" > "$filename"

notify-send "Yazi" "Saved: $filename"!/bin/bash
