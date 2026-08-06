#!/usr/bin/env bash

case "$1" in
    up)   brightnessctl set 5%+ ;;
    down) brightnessctl set 5%- ;;
esac

PERCENT=$(brightnessctl -m info | awk -F, '{print $4}' | tr -d '%')

ICON="display-brightness-symbolic"
(( PERCENT < 33 )) && ICON="display-brightness-low-symbolic"

notify-send \
    --app-name="Brightness" \
    --urgency=low \
    --expire-time=1000 \
    --transient \
    --icon="$ICON" \
    --hint="int:value:${PERCENT}" \
    --hint="string:synchronous:brightness" \
    "Brightness: ${PERCENT}%"
