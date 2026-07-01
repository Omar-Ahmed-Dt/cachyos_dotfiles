#!/bin/bash

WALL="$1"

cp "$WALL" ~/.cache/wallpaper.jpg
pkill swaybg
swaybg -i ~/.cache/wallpaper.jpg -m fill &
