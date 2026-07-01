# Wacom Tablet Setup on Sway (Wayland) — Arch Linux

## Overview

Two components handle the tablet:

| Component | What it does |
|-----------|-------------|
| `wacom_sway.sh` + `wacom.service` | Maps the stylus to the correct monitor when the tablet is plugged in (triggered by udev) |
| `wacom-pad-daemon.py` + `wacom-pad.service` | Listens for pad button presses and sends key combos via `wtype` (runs as a persistent daemon) |

---

## 1. Dependencies

```bash
sudo pacman -S jq libwacom python-evdev wtype libnotify
```

---

## 2. Find your device identifiers

Plug in the tablet, then run:

```bash
# Stylus identifier (needed in wacom_sway.sh)
swaymsg -t get_inputs | jq '.[] | select(.type=="tablet_tool") | .identifier'

# Your monitor output name (to map the stylus to)
swaymsg -t get_outputs | jq -r '.[].name'

# USB vendor ID (should be 056a for all Wacom tablets)
lsusb | grep -i wacom
```

On this machine:
- Stylus identifier: `1386:884:Wacom_Intuos_S_Pen`
- Monitor: `eDP-1`
- Vendor ID: `056a`

---

## 3. The setup script

**`~/scripts/wacom_sway.sh`** — maps the stylus to your monitor and sends a notification.
Run by the system-level `wacom.service` when udev detects the tablet.

```bash
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

```

Make it executable:

```bash
chmod +x ~/scripts/wacom_sway.sh
```

---

## 4. The pad button daemon

**`~/.local/bin/wacom-pad-daemon.py`** — listens for pad button events via evdev and fires
key combos with `wtype`. Loops forever so it handles unplug/replug without restarting.

```python
#!/usr/bin/env python3
"""Listen to Wacom pad buttons and trigger keybindings via wtype."""
import subprocess
import sys
import time
from evdev import InputDevice, ecodes, list_devices

BINDINGS = {
    ecodes.BTN_0: ["wtype", "-M", "ctrl", "z", "-m", "ctrl"],      # Undo
    ecodes.BTN_1: ["wtype", "-M", "ctrl", "1", "-m", "ctrl"],      # Ctrl+1
    ecodes.BTN_2: ["wtype", "-M", "ctrl", "4", "-m", "ctrl"],      # Ctrl+4
    ecodes.BTN_3: ["wtype", "-M", "ctrl", "5", "-m", "ctrl"],      # Ctrl+5
}

def find_pad():
    for path in list_devices():
        try:
            dev = InputDevice(path)
            if "pad" in dev.name.lower() and "wacom" in dev.name.lower():
                return dev
        except Exception:
            pass
    return None

while True:
    pad = find_pad()
    if not pad:
        time.sleep(2)
        continue

    print(f"Listening on {pad.name} ({pad.path})", flush=True)
    try:
        for event in pad.read_loop():
            if event.type == ecodes.EV_KEY and event.value == 1:
                cmd = BINDINGS.get(event.code)
                if cmd:
                    subprocess.run(cmd)
    except OSError:
        print("Wacom pad disconnected, waiting for reconnect...", flush=True)
```

Make it executable:

```bash
chmod +x ~/.local/bin/wacom-pad-daemon.py
```

### Finding the correct button codes

If the buttons don't work, check what codes your pad sends:

```bash
sudo evtest   # pick the "Wacom Intuos ... Pad" device, then press each button
```

Map the reported codes (`BTN_0`, `BTN_1`, etc.) to the `BINDINGS` dict in the script.

---

## 5. Systemd services

### System-level service (triggered by udev)

**`/etc/systemd/system/wacom.service`**

```ini
[Unit]
Description=Wacom Tablet Setup (Sway)

[Service]
Type=oneshot
User=omar
ExecStart=/home/omar/scripts/wacom_sway.sh
```

```bash
sudo systemctl daemon-reload
```

### User-level pad daemon service

**`~/.config/systemd/user/wacom-pad.service`**

```ini
[Unit]
Description=Wacom Pad Button Daemon
After=graphical-session.target
PartOf=graphical-session.target
StartLimitIntervalSec=0

[Service]
ExecStart=%h/.local/bin/wacom-pad-daemon.py
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
```

Enable it so it starts automatically with your Sway session:

```bash
systemctl --user daemon-reload
systemctl --user enable --now wacom-pad.service
```

---

## 6. udev rule

**`/etc/udev/rules.d/77-wacom.rules`** — fires `wacom.service` whenever the tablet is plugged in.

```
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", TAG+="systemd", ENV{SYSTEMD_WANTS}+="wacom.service"
```

`056a` is Wacom's USB vendor ID — works for all Wacom tablets.

```bash
sudo udevadm control --reload-rules
```

---

## 7. Apply everything (fresh install checklist)

```bash
# 1. Install dependencies
sudo pacman -S jq libwacom python-evdev wtype libnotify

# 2. Copy scripts
cp ~/scripts/wacom_sway.sh ~/scripts/wacom_sway.sh        # already in dotfiles
cp ~/.local/bin/wacom-pad-daemon.py ~/.local/bin/          # already in dotfiles
chmod +x ~/scripts/wacom_sway.sh
chmod +x ~/.local/bin/wacom-pad-daemon.py

# 3. Install system service
sudo cp /path/to/dotfiles/systemd/wacom.service /etc/systemd/system/wacom.service
sudo systemctl daemon-reload

# 4. Install udev rule
sudo cp /path/to/dotfiles/udev/rules.d/77-wacom.rules /etc/udev/rules.d/77-wacom.rules
sudo udevadm control --reload-rules

# 5. Enable user pad daemon
cp /path/to/dotfiles/systemd/user/wacom-pad.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now wacom-pad.service
```

---

## 8. Verification

```bash
# Check pad daemon is running
systemctl --user status wacom-pad.service

# Unplug and replug the tablet, then check stylus is mapped
swaymsg -t get_inputs | jq '.[] | select(.type=="tablet_tool") | {name, mapped_to_output}'
# Expected: "mapped_to_output": "eDP-1"

# Watch udev trigger live
sudo journalctl -fu wacom.service

# Watch pad daemon live (unplug/replug, press buttons)
journalctl --user -fu wacom-pad.service
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| No notification on plug-in | udev rule not installed | `sudo cp 77-wacom.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules` |
| `mapped_to_output: null` | `wacom.service` never ran | `sudo systemctl start wacom.service` to test, then replug |
| Pad buttons do nothing | Wrong BTN codes | Run `sudo evtest` on the pad device to find the real codes |
| Daemon hits restart limit | `StartLimitIntervalSec` missing from `[Unit]` | Add `StartLimitIntervalSec=0` to the `[Unit]` section |
| `swaymsg: Unable to retrieve socket path` | SWAYSOCK not set | Script finds it via `/run/user/UID/sway-ipc.*.sock` — check UID is correct |
