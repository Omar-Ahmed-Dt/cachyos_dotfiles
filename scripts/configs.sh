#!/usr/bin/env bash

EDITOR="nvim"
TERMINAL="kitty"

actions=(
  configs
  zsh
  sway
  waybar_configs
  waybar_colors
  kitty
  swayimg
  yazi_configs
  yazi_keymaps
)

# selected=$(printf '%s\n' "${actions[@]}" | rofi -dmenu -i -p "Edit Configs")
selected=$(printf '%s\n' "${actions[@]}" | fuzzel -d -p "Edit ")

case "$selected" in
  configs)         $EDITOR "$HOME/scripts/configs.sh" ;;
  zsh)             $EDITOR "$HOME/.zshrc" ;;
  sway)            $EDITOR "$HOME/.config/sway/config" ;;
  waybar_configs)  $EDITOR "$HOME/.config/waybar/config.jsonc" ;;
  waybar_colors)   $EDITOR "$HOME/.config/waybar/style.css" ;;
  kitty)           $EDITOR "$HOME/.config/kitty/kitty.conf" ;;
  swayimg)         $EDITOR "$HOME/.config/swayimg/init.lua" ;;
  yazi_configs)    $EDITOR "$HOME/.config/yazi/yazi.toml" ;;
  yazi_keymaps)    $EDITOR "$HOME/.config/yazi/keymap.toml" ;;
esac
