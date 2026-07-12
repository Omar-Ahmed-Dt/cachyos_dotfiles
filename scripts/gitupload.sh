#!/bin/bash
copy_to_dir() {
    local dest="${@: -1}"
    local sources=("${@:1:$#-1}")

    mkdir -p "$dest"
    cp -r "${sources[@]}" "$dest/"
}

gitdir="$HOME/Documents/GitHub/cachyos_dotfiles"
config="$gitdir/config"

mkdir -p $config


pacman -Qeq > "$gitdir/pkgs.txt"

cd "$HOME/.config" || exit

cp -r fuzzel rofi zathura htop pcmanfm yay mimeapps.list dunst \
xdg-desktop-portal xdg-desktop-portal-termfilechooser imv sway swayimg \
swaylock gtk-3.0 gtk-4.0 waybar "$config/"


cp -r "$HOME/scripts" "$gitdir/"

copy_to_dir "$HOME/.config/dmscripts/config" "$config/dmscripts/"

copy_to_dir "$HOME/.config/ncmpcpp/config" "$config/ncmpcpp/"
cp "$HOME/.config/ncmpcpp/bindings" "$config/ncmpcpp/"

copy_to_dir "$HOME/.config/mpd/mpd.conf" "$config/mpd/"
copy_to_dir "$HOME/.config/kitty/kitty.conf" "$config/kitty/"

copy_to_dir "$HOME/.oh-my-zsh/custom/themes/fishy.zsh-theme" "$gitdir/zsh/"
cp "$HOME/.zshrc" "$gitdir/zsh/zshrc"

copy_to_dir "$HOME/.config/mpv/mpv.conf" "$config/mpv/"
cp "$HOME/.config/mpv/input.conf" "$config/mpv/"

copy_to_dir "$HOME/.config/nvim/lua" "$config/nvim/"

# Yazi configs
copy_to_dir "$HOME/.config/yazi/"*.toml "$config/yazi/"
cp "$HOME/.config/yazi/init.lua" "$config/yazi/"

mkdir -p "$config/yazi/flavors/"
find "$HOME/.config/yazi/flavors" -maxdepth 1 -type d -name "*.yazi" -printf "%f\n" > "$config/yazi/flavors/flavors.txt"

mkdir -p "$config/yazi/plugins/"
find "$HOME/.config/yazi/plugins" -maxdepth 1 -type d -name "*.yazi" -printf "%f\n" > "$config/yazi/plugins/plugins.txt"

# obsidian
copy_to_dir $HOME/Dropbox/obsidian/.obsidian/snippets/* $gitdir/obsidian/

# sigle files
mkdir -p "$gitdir/system"
doas cp /etc/sudoers.d/10-installer \
        /etc/doas.conf \
        /etc/default/grub \
        /etc/hosts \
        /etc/resolv.conf \
        /etc/samba/smb.conf \
        "$gitdir/system/"

doas chown -R "$USER:$USER" "$gitdir/system"

echo "... Backup done ..."
