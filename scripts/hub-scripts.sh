#!/usr/bin/env bash
choice=$(printf "Notes\nKill\nPDF Files" | fuzzel -d -i -p "Run: ")
case "$choice" in
    "Notes")
        action=$(printf "Copy\nEdit" | fuzzel -d -i -p "Notes: ")
        case "$action" in
            "Copy")
                cat ~/dmnote | fuzzel --dmenu | wl-copy
                ;;
            "Edit")
                kitty -e nvim ~/dmnote
                ;;
        esac
        ;;
    "PDF Files")
        ~/scripts/pdf.sh
        ;;
    "Kill")
        ~/scripts/kill.sh
        ;;
esac
