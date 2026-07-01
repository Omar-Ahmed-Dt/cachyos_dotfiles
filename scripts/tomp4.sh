# #!/bin/bash
for file in "$@"; do
    base_name="${file%.*}"
    output_file="${base_name}.mp4"

    ffmpeg -i "$file" "$output_file"

    if [ $? -eq 0 ]; then
        notify-send "Converted $file → $output_file"
    else
        notify-send "Failed to convert $file"
    fi
done
