#!/bin/bash

song=$(ncmpcpp --current-song="%f ")

# Extract the current/total timestamp using awk (handles both playing and paused)
timestamps=$(mpc | grep -E "playing|paused" | awk '{print $3}')

# Check if MPD is running and determine output
if [ -z "$song" ] || [ -z "$timestamps" ]; then
    echo "No_music_playing"
else
    if mpc | grep -q paused; then
        echo "$song [$timestamps] ⏸"
    else
        echo "$song [$timestamps] ▶"
    fi
fi
