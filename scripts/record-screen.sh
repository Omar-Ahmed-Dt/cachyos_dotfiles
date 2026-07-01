#!/bin/bash

echo "Select recording mode:"
echo "1) Full screen"
echo "2) Selected area"
echo "3) Audio only"
read -rp "Enter choice (1, 2 or 3): " choice

# If no input → exit
if [[ -z "$choice" ]]; then
    echo "No option selected. Exiting..."
    exit 1
fi

case $choice in
    1)
        OUTPUT=~/Videos/wf-record-$(date +"%Y-%m-%d_%H-%M-%S").mp4
        echo "Recording full screen..."
        wf-recorder \
        -f "$OUTPUT" \
        -r 30 \
        --codec libx264 \
        --preset slow \
        --crf 18 \
        --audio \
        --audio-codec aac
        ;;
    2)
        OUTPUT=~/Videos/wf-record-$(date +"%Y-%m-%d_%H-%M-%S").mp4
        echo "Recording selected area..."
        wf-recorder -g "$(slurp)" \
        -f "$OUTPUT" \
        -r 30 \
        --codec libx264 \
        --preset slow \
        --crf 18 \
        --audio \
        --audio-codec aac
        ;;
    3)
        OUTPUT=~/Videos/audio-record-$(date +"%Y-%m-%d_%H-%M-%S").m4a
        echo "Recording audio only..."
        pw-record "$OUTPUT"
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac

echo "Recording saved to: $OUTPUT"
