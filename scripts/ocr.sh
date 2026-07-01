#!/usr/bin/env bash
# sudo pacman -S tesseract-data-eng tesseract-data-ara

mkdir -p ~/.cache/ocr

grim -g "$(slurp)" ~/.cache/ocr/pic.png && \
tesseract ~/.cache/ocr/pic.png stdout -l ara+eng --psm 6 | wl-copy && \
notify-send -t 1000 "OCR" "Arabic/English text copied to clipboard"
