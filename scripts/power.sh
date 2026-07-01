#!/usr/bin/env bash

OPTIONS="lock\nsuspend\nexit\nreboot\nshutdown"

menu() {
    # echo -e "$OPTIONS" | rofi -dmenu -i -p "Choose action:"
    echo -e "$OPTIONS" | fuzzel -d -i -p "Choose action: "
}

confirm() {
    # printf "Yes" | rofi -dmenu -i -p "Really $1?"
    printf "Yes" | fuzzel -d -i -p "Really $1? "
}

OPT="$(menu)"

case "$OPT" in
    lock)
        [ "$(confirm exit)" = "Yes" ] && swaylock 
        ;;
    exit)
        [ "$(confirm exit)" = "Yes" ] && swaymsg exit
        # [ "$(confirm exit)" = "Yes" ] && pkill sway
        ;;
    suspend)
        if [ "$(confirm suspend)" = "Yes" ]; then
            systemctl suspend
        fi
        ;;
    reboot)
        [ "$(confirm reboot)" = "Yes" ] && systemctl reboot
        ;;
    shutdown)
        [ "$(confirm shutdown)" = "Yes" ] && systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
