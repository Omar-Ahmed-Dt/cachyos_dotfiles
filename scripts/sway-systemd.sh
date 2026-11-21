#!/bin/sh
# Start graphical-session.target for this sway instance (gammastep, wacom-*),
# and stop it again when sway shuts down. Run once from sway with `exec`.
vars="DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway XDG_SESSION_TYPE=wayland"

stop_session() {
    systemctl --user stop sway-session.target
    # Also stop graphical-session.target explicitly: when sway exits, services
    # like xdg-desktop-portal-gtk crash and queue a restart, and systemd then
    # refuses the implicit stop, leaving gammastep etc. on the dead session.
    # An explicit stop replaces those queued jobs.
    systemctl --user stop graphical-session.target
}

# Stop a session left over from a previous sway so services reconnect to this one.
stop_session
dbus-update-activation-environment --systemd $vars
systemctl --user start sway-session.target

# Block until sway exits (swaymsg fails when the socket closes), then stop.
swaymsg -t subscribe '["shutdown"]' >/dev/null 2>&1
stop_session
