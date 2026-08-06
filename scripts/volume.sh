#!/usr/bin/env bash

SINK="@DEFAULT_AUDIO_SINK@"

case "$1" in
    up)   wpctl set-volume -l 1.0 "$SINK" 5%+ ;;
    down) wpctl set-volume "$SINK" 5%- ;;
    mute) wpctl set-mute "$SINK" toggle ;;
esac

INFO=$(wpctl get-volume "$SINK")
PERCENT=$(awk '{printf "%.0f", $2 * 100}' <<< "$INFO")

if [[ "$INFO" == *"[MUTED]"* ]]; then
    notify-send \
        --app-name="Volume" \
        --urgency=low \
        --expire-time=1000 \
        --transient \
        --icon="audio-volume-muted-symbolic" \
        --hint="int:value:${PERCENT}" \
        --hint="string:synchronous:volume" \
        "Volume muted"
else
    ICON="audio-volume-high-symbolic"
    (( PERCENT < 66 )) && ICON="audio-volume-medium-symbolic"
    (( PERCENT < 33 )) && ICON="audio-volume-low-symbolic"
    (( PERCENT == 0 )) && ICON="audio-volume-muted-symbolic"

    notify-send \
        --app-name="Volume" \
        --urgency=low \
        --expire-time=1000 \
        --transient \
        --icon="$ICON" \
        --hint="int:value:${PERCENT}" \
        --hint="string:synchronous:volume" \
        "Volume: ${PERCENT}%"
fi
