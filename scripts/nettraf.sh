#!/bin/sh

# Bytes
update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=${XDG_CACHE_HOME:-$HOME/.cache}/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}

rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

printf " %3sB -  %3sB\\n" $(numfmt --to=iec $rx) $(numfmt --to=iec $tx)

# bits
# update() {
#     sum=0
#     for arg; do
#         read -r i < "$arg"
#         sum=$(( sum + i ))
#     done
#
#     cache=${XDG_CACHE_HOME:-$HOME/.cache}/${1##*/}
#     [ -f "$cache" ] && read -r old < "$cache" || old=0
#
#     printf %d\\n "$sum" > "$cache"
#
#     # Convert bytes to bits
#     printf %d\\n $(( (sum - old) * 8 ))
# }
#
# rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
# tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)
#
# printf " %4sbit/s -  %4sbit/s\\n" \
#     "$(numfmt --to=si "$rx")" \
#     "$(numfmt --to=si "$tx")"


###


# IFACE="wlan0"
#
# RX_FILE="/sys/class/net/$IFACE/statistics/rx_bytes"
# TX_FILE="/sys/class/net/$IFACE/statistics/tx_bytes"
# CACHE="/tmp/i3blocks-net-speed-$IFACE"
#
# if [ ! -f "$RX_FILE" ] || [ ! -f "$TX_FILE" ]; then
#     echo "down"
#     exit 0
# fi
#
# RX="$(cat "$RX_FILE")"
# TX="$(cat "$TX_FILE")"
# NOW="$(date +%s)"
#
# format_bits() {
#     awk -v bps="$1" '
#     BEGIN {
#         if (bps < 1000) {
#             printf "%.0f bps", bps
#         } else if (bps < 1000*1000) {
#             printf "%.1f Kbps", bps/1000
#         } else if (bps < 1000*1000*1000) {
#             printf "%.1f Mbps", bps/1000/1000
#         } else {
#             printf "%.1f Gbps", bps/1000/1000/1000
#         }
#     }'
# }
#
# if [ -f "$CACHE" ]; then
#     read -r OLD_RX OLD_TX OLD_NOW < "$CACHE"
#
#     DIFF_TIME=$((NOW - OLD_NOW))
#
#     if [ "$DIFF_TIME" -gt 0 ]; then
#         DOWN=$(( ((RX - OLD_RX) / DIFF_TIME) * 8 ))
#         UP=$(( ((TX - OLD_TX) / DIFF_TIME) * 8 ))
#
#         echo "↓ $(format_bits "$DOWN") ↑ $(format_bits "$UP")"
#     else
#         echo "↓ 0 bps ↑ 0 bps"
#     fi
# else
#     echo "↓ 0 bps ↑ 0 bps"
# fi
#
# echo "$RX $TX $NOW" > "$CACHE"
