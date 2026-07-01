#!/usr/bin/env bash
selection=$(ps -eo user=,pid=,comm= \
    | awk -v user="$USER" '$1 == user {printf "%-10s %-6s %s\n", $1, $2, $3}' \
    | fuzzel --dmenu -p "Kill process ")
[ -z "$selection" ] && exit 0
pid=$(echo "$selection" | awk '{print $2}')
name=$(echo "$selection" | awk '{print $3}')
confirm=$(echo -e "Yes\nNo" | fuzzel --dmenu -p "Kill $name? ")
if [[ "$confirm" == "Yes" ]]; then
    kill "$pid"
fi
