
#!/bin/bash

VIDEO_DIR="$HOME/Videos"
mkdir -p "$VIDEO_DIR"

echo "Select recording mode:"
echo "1) Full screen"
echo "2) Selected area"
echo "3) Audio only"

read -rp "Enter choice (1, 2 or 3): " choice

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Video settings - tested for correct colors and quality
VIDEO_OPTS=(
    # -r 30
    -r 60
    -c libx264
    -p preset=medium
    -p crf=14
    -x yuvj420p
)

case "$choice" in
    1)
        OUTPUT="$VIDEO_DIR/screen-$TIMESTAMP.mp4"
        echo "Recording full screen..."

        wf-recorder \
            -f "$OUTPUT" \
            "${VIDEO_OPTS[@]}" \
            --audio \
            -C aac
        ;;

    2)
        echo "Select the area to record..."

        GEOMETRY=$(slurp) || exit 1

        if [[ -z "$GEOMETRY" ]]; then
            echo "No area selected. Exiting..."
            exit 1
        fi

        OUTPUT="$VIDEO_DIR/area-$TIMESTAMP.mp4"
        echo "Recording selected area..."

        wf-recorder \
            -g "$GEOMETRY" \
            -f "$OUTPUT" \
            "${VIDEO_OPTS[@]}" \
            --audio \
            -C aac
        ;;

    3)
        OUTPUT="$VIDEO_DIR/audio-$TIMESTAMP.wav"
        echo "Recording audio only..."

        pw-record "$OUTPUT"
        ;;

    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac

STATUS=$?

if [[ $STATUS -eq 0 ]]; then
    echo "Recording saved to: $OUTPUT"
else
    echo "Recording failed."
fi

exit "$STATUS"

