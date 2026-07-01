#!/bin/bash
declare options=("Google
Brave
Waterfox
Chromium"
)

# choice=$(echo -e "${options[@]}" | rofi -dmenu -i -p 'launch browser: ' )
choice=$(echo -e "${options[@]}" | fuzzel -d -i -p 'launch browser: ' )

case "$choice" in 
   Waterfox)
       choice="waterfox"
   ;;
   Google)
       choice="google-chrome-stable"
   ;;
   Chromium)
       choice="chromium"
   ;;
    Brave) 
        exec brave --password-store=basic
    ;;
esac
"$choice"
