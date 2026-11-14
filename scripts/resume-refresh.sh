#!/bin/sh
# Refresh waybar weather (signal 8) after resuming from suspend.
dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" |
while read -r line; do
    case "$line" in
        *"boolean false"*) sleep 3; pkill -RTMIN+8 waybar ;;
    esac
done
