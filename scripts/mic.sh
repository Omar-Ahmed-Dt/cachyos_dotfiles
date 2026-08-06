#!/usr/bin/env bash

SRC="@DEFAULT_AUDIO_SOURCE@"

case "$1" in
    up)     wpctl set-volume -l 1.0 "$SRC" 5%+ ;;
    down)   wpctl set-volume "$SRC" 5%- ;;
    toggle) wpctl set-mute "$SRC" toggle ;;
esac

INFO=$(wpctl get-volume "$SRC")

if [[ "$INFO" == *"[MUTED]"* ]]; then
    notify-send \
        --app-name="Microphone" \
        --urgency=low \
        --expire-time=1000 \
        --transient \
        --icon="microphone-sensitivity-muted-symbolic" \
        --hint="string:synchronous:microphone" \
        "Microphone muted"
else
    PERCENT=$(awk '{printf "%.0f", $2 * 100}' <<< "$INFO")

    notify-send \
        --app-name="Microphone" \
        --urgency=low \
        --expire-time=1000 \
        --transient \
        --icon="microphone-sensitivity-high-symbolic" \
        --hint="int:value:${PERCENT}" \
        --hint="string:synchronous:microphone" \
        "Microphone: ${PERCENT}%"
fi
