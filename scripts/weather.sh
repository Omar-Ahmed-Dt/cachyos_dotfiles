#!/bin/sh

key="d9bb0961c0b0d9fae76fe7bb6429e3e5"
cityid="347497"
lang="en"
unit="metric"

if [ "$unit" = "metric" ]; then
    symbol="C"
else
    symbol="F"
fi

data=$(curl -fsS "https://api.openweathermap.org/data/2.5/weather?id=$cityid&appid=$key&units=$unit&lang=$lang") || exit 1

Temp=$(printf '%s\n' "$data" | jq -r '.main.temp | round')
iconval=$(printf '%s\n' "$data" | jq -r '.weather[0].icon')

case "$iconval" in
    01d) icon="☀" ;;  # Clear sky (day)
    01n) icon="☾" ;;  # Clear sky (night)
    02*) icon="☁" ;;  # Few clouds
    03*) icon="☁" ;;  # Scattered clouds
    04*) icon="☁" ;;  # Broken clouds
    09*) icon="☂" ;;  # Shower rain
    10*) icon="☂" ;;  # Rain
    11*) icon="ϟ" ;;  # Thunderstorm
    13*) icon="❄" ;;  # Snow
    50*) icon="≋" ;;  # Mist
    *)   icon="◌" ;;
esac

printf "<span color='%s'>%s</span> %s°%s\n" '#dbbc7f' "$icon" "$Temp" "$symbol"
