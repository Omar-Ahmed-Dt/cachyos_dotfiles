#!/bin/bash
# pkgs: grim, slurp, wl-clipboard, tesseract, tesseract-data-eng, tesseract-data-ara

mkdir -p ~/.cache/ocr

grim -g "$(slurp)" ~/.cache/ocr/pic.png && \
tesseract -l eng ~/.cache/ocr/pic.png stdout > ~/.cache/ocr/out.txt && \
wl-copy < ~/.cache/ocr/out.txt && \
notify-send -t 1000 'Text copied to clipboard'
