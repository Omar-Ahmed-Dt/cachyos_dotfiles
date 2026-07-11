#!/bin/bash

gitdir="$HOME/Documents/GitHub/cachyos_dotfiles"
config="$gitdir/config"

pacman -Qeq > "$gitdir/pkgs.txt"

cd "$HOME/.config" || exit

cp -r fuzzel rofi zathura htop dmscripts pcmanfm yay mimeapps.list dunst \
xdg-desktop-portal xdg-desktop-portal-termfilechooser imv sway swayimg \
swaylock gtk-3.0 gtk-4.0 waybar "$config/"

rm -f "$config/dmscripts/dmnote"

cp -r "$HOME/scripts" "$gitdir/"

cp "$HOME/.config/ncmpcpp/config" "$config/ncmpcpp/"
cp "$HOME/.config/ncmpcpp/bindings" "$config/ncmpcpp/"

cp "$HOME/.config/mpd/mpd.conf" "$config/mpd/"
cp "$HOME/.config/kitty/kitty.conf" "$config/kitty/"

cp "$HOME/.zshrc" "$gitdir/zsh/zshrc"
cp "$HOME/.oh-my-zsh/custom/themes/fishy.zsh-theme" "$gitdir/zsh/"

cp "$HOME/.config/mpv/mpv.conf" "$config/mpv/"
cp "$HOME/.config/mpv/input.conf" "$config/mpv/"

cp -r "$HOME/.config/nvim/lua" "$config/nvim/"

cp "$HOME/.config/yazi/"*.toml "$config/yazi/"
cp "$HOME/.config/yazi/init.lua" "$config/yazi/"

find "$HOME/.config/yazi/flavors" -maxdepth 1 -type d -name "*.yazi" -printf "%f\n" > "$config/yazi/flavors/flavors.txt"

find "$HOME/.config/yazi/plugins" -maxdepth 1 -type d -name "*.yazi" -printf "%f\n" > "$config/yazi/plugins/plugins.txt"

cp /home/omar/Dropbox/obsidian/.obsidian/snippets/* $gitdir/obsidian/

echo "Backup done."
