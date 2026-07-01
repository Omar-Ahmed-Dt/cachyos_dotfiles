#!/bin/bash
set -e

# ---- Set Wayland/Sway env by looking up well-known socket paths ----
# (reading /proc/PID/environ is locked down on this system; socket paths are predictable)
XDG_RUNTIME_DIR="/run/user/$(id -u omar)"
export XDG_RUNTIME_DIR

SWAYSOCK="$(ls "$XDG_RUNTIME_DIR"/sway-ipc.*.sock 2>/dev/null | head -n1)"
export SWAYSOCK

WAYLAND_DISPLAY="$(basename "$(ls "$XDG_RUNTIME_DIR"/wayland-[0-9] 2>/dev/null | head -n1)")"
export WAYLAND_DISPLAY

export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# ---- Wait until Sway sees the tablet ----
for i in $(seq 20); do
    swaymsg -t get_inputs 2>/dev/null | grep -qi wacom && break
    sleep 1
done

# Map stylus to your monitor
STYLUS_ID=$(swaymsg -t get_inputs --raw | \
    jq -r '.[] | select(.type=="tablet_tool") | .identifier' | head -n1)

if [ -n "$STYLUS_ID" ]; then
    swaymsg input "$STYLUS_ID" map_to_region 15 83 1893 987
fi

notify-send "Wacom Tablet is Plugged" -t 1500 -i /home/omar/logo/theme.png
