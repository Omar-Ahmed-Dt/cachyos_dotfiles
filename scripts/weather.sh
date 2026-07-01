# !/bin/sh
key="074b883ed346ff4fa0dcfa3290dd14d9"
cityid="347497" #city id can be found at https://openweathermap.org in the url bar
lang="us"
unit="metric" # use Celsius or Fahrenheit


if [ $unit == "metric" ]; then
    symbol="C"
else
    symbol="F"
fi

data=$(curl "api.openweathermap.org/data/2.5/weather?id=$cityid&appid=$key&units=$unit&lang=$lang" -s)

Temp=$(echo $data | jq ".main.temp" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
# Desc=$(echo $data | jq ".weather[].description" | bc | awk '{$1=$1};$1')
icons=$(echo $data | jq -r .weather[].icon | tr '\n' ' ')
iconval=${icons%?}
            case $iconval in
                01*) icon="☀️";;
                02*) icon="⛅";;
                03*) icon="⛅";;
                04*) icon="☁️";;
                09*) icon="🌧️";;
                10*) icon="🌧️";;
                11*) icon="🌩️";;
                13*) icon="❄️ ";;
                50*) icon="🌫️";;
            esac

printf "$icon $Temp°$symbol"
