#!/usr/bin/env bash
# PipeWire-native volume control using wpctl

SINK="@DEFAULT_AUDIO_SINK@"   # Automatically follows current default sink
STEP="5%"                     # Volume step

case "$1" in
    up)
        wpctl set-volume "$SINK" "$STEP"+ > /dev/null
        ;;
    down)
        wpctl set-volume "$SINK" "$STEP"- > /dev/null
        ;;
    mute|toggle)
        wpctl set-mute "$SINK" toggle > /dev/null
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

# ----------------------------
# Get volume info
# ----------------------------

VOL_INFO=$(wpctl get-volume "$SINK")
VOL=$(awk '{print $2}' <<< "$VOL_INFO")
VOL_PCT=$(printf "%.0f" "$(echo "$VOL * 100" | bc -l)")

# Check mute state
if grep -q '\[MUTED\]' <<< "$VOL_INFO"; then
    notify-send -u low -t 1000 -r 999 "🔇 Muted"
else
    notify-send -u low -t 1000 -r 999 "🔊 Volume: ${VOL_PCT}%"
fi
