#!/bin/bash
set -euo pipefail

PDF_VIEWER=zathura

files="$(find "$HOME" -maxdepth 4 \
  -path "$HOME/home_docker" -prune -o \
  -path "$HOME/aur" -prune -o \
  -iname "*.pdf" -print 2>/dev/null)"

choice=$(printf '%s\n' "$files" \
    | cut -d '/' -f4- \
    | sed -e 's/Documents/Dcs/g' \
        -e 's/Downloads/Dwn/g' \
        -e 's/Pictures/Pic/g' \
        -e 's/Images/Img/g' \
        -e 's/.pdf//g' \
    | sort -g \
    | fuzzel -d -p "PDF: " -w 80) || exit 1

if [ -n "$choice" ]; then
    file=$(printf '%s' "$choice" \
        | sed -e 's/Dcs/Documents/g' \
            -e 's/Dwn/Downloads/g' \
            -e 's/Pic/Pictures/g' \
            -e 's/Img/Images/g')
    "$PDF_VIEWER" "$HOME/${file}.pdf"
fi
