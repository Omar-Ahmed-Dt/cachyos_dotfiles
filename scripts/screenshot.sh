#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/screenshots"
mkdir -p "$DIR"

MENU=$(
  printf "%s\n" \
    "1_A_clip" \
    "2_A_save" \
    "3_A_clip_save" \
    "4_W_clip" \
    "5_W_save" \
    "6_W_clip_save" \
    "7_Full_clip" \
    "22_Full_save" \
    "33_Full_clip_save" |
    fuzzel -d -i -p "Choose action: "
)

timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"
file="$DIR/screenshot_$timestamp.png"

region_shot_to_clip() {
  grim -g "$(slurp)" - | wl-copy
  notify-send "Screenshot" "Area copied to clipboard"
}

region_shot_to_save() {
  grim -g "$(slurp)" "$file"
  notify-send "Screenshot saved" "$file"
}

region_shot_to_both() {
  grim -g "$(slurp)" - | tee "$file" | wl-copy
  notify-send "Screenshot" "Area copied and saved to $file"
}

window_rect() {
  swaymsg -t get_tree | jq -r '
    recurse(.nodes[]?, .floating_nodes[]?)
    | select(.pid? and .visible?)
    | .rect
    | "\(.x),\(.y) \(.width)x\(.height)"
  ' | slurp -r
}

window_shot_to_clip() {
  grim -g "$(window_rect)" - | wl-copy
  notify-send "Screenshot" "Window copied to clipboard"
}

window_shot_to_save() {
  grim -g "$(window_rect)" "$file"
  notify-send "Screenshot saved" "$file"
}

window_shot_to_both() {
  grim -g "$(window_rect)" - | tee "$file" | wl-copy
  notify-send "Screenshot" "Window copied and saved to $file"
}

full_shot_to_clip() {
  grim - | wl-copy
  notify-send "Screenshot" "Full screen copied to clipboard"
}

full_shot_to_save() {
  grim "$file"
  notify-send "Screenshot saved" "$file"
}

full_shot_to_both() {
  grim - | tee "$file" | wl-copy
  notify-send "Screenshot" "Full screen copied and saved to $file"
}

case "${MENU:-}" in
  1_A_clip)       region_shot_to_clip ;;
  2_A_save)       region_shot_to_save ;;
  3_A_clip_save)  region_shot_to_both ;;
  4_W_clip)       window_shot_to_clip ;;
  5_W_save)       window_shot_to_save ;;
  6_W_clip_save)  window_shot_to_both ;;
  7_Full_clip)    full_shot_to_clip ;;
  22_Full_save)   full_shot_to_save ;;
  33_Full_clip_save) full_shot_to_both ;;
  *)              exit 0 ;;
esac
