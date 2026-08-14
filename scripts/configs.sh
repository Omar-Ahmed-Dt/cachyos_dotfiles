#!/usr/bin/env bash

EDITOR="nvim"
TERMINAL="foot"

actions=(
  configs
  zsh
  sway
  waybar_configs
  waybar_colors
  foot
  swayimg
  yazi_configs
  yazi_keymaps
)

# selected=$(printf '%s\n' "${actions[@]}" | rofi -dmenu -i -p "Edit Configs")
selected=$(printf '%s\n' "${actions[@]}" | fuzzel -d -p "Edit ")

case "$selected" in
  configs)         $TERMINAL $EDITOR "$HOME/scripts/configs.sh" ;;
  zsh)             $TERMINAL $EDITOR "$HOME/.zshrc" ;;
  sway)            $TERMINAL $EDITOR "$HOME/.config/sway/config" ;;
  waybar_configs)  $TERMINAL $EDITOR "$HOME/.config/waybar/config.jsonc" ;;
  waybar_colors)   $TERMINAL $EDITOR "$HOME/.config/waybar/style.css" ;;
  foot)            $TERMINAL $EDITOR "$HOME/.config/foot/foot.ini" ;;
  swayimg)         $TERMINAL $EDITOR "$HOME/.config/swayimg/init.lua" ;;
  yazi_configs)    $TERMINAL $EDITOR "$HOME/.config/yazi/yazi.toml" ;;
  yazi_keymaps)    $TERMINAL $EDITOR "$HOME/.config/yazi/keymap.toml" ;;
esac
