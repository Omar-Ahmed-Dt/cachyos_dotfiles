#!/bin/bash
# browser="net.waterfox.waterfox"
browser="waterfox"
engine=$(printf "DuckDuckGo\nStartpage\nGoogle\nYouTube\nAUR" \
| fuzzel -d -p "Engine: ")
[ -z "$engine" ] && exit
query=$(echo "" | fuzzel -d -p "Search: ")
[ -z "$query" ] && exit
query=${query// /+}
case $engine in
  Google) url="https://www.google.com/search?q=$query" ;;
  DuckDuckGo) url="https://duckduckgo.com/?q=$query" ;;
  Startpage) url="https://www.startpage.com/do/search?q=$query" ;;
  YouTube) url="https://www.youtube.com/results?search_query=$query" ;;
  AUR) url="https://aur.archlinux.org/packages?K=$query" ;;
esac
"$browser" "$url" >/dev/null 2>&1 &
