#!/usr/bin/env bash

set -u

if (( $# == 0 )); then
    exit 0
fi

declare -a images=()
declare -a media=()
declare -a pdfs=()
declare -a office=()
declare -a rnotes=()
declare -a texts=()
declare -a archives=()
declare -a fallback=()

# Start GUI programs independently from Yazi.
detach() {
    nohup "$@" >/dev/null 2>&1 &
}

for path in "$@"; do
    if [[ ! -e "$path" ]]; then
        printf 'File does not exist: %s\n' "$path" >&2
        continue
    fi

    lower_path="${path,,}"

    # Check extensions that may have generic MIME types first.
    case "$lower_path" in
        *.rnote)
            rnotes+=("$path")
            continue
            ;;

        *.odt|*.ods|*.odp|*.doc|*.docx|*.xls|*.xlsx|*.ppt|*.pptx)
            office+=("$path")
            continue
            ;;
    esac

    mime="$(
        file --brief --mime-type -- "$path" 2>/dev/null ||
            printf '%s' "application/octet-stream"
    )"

    case "$mime" in
        image/*)
            images+=("$path")
            ;;

        video/*|audio/*)
            media+=("$path")
            ;;

        application/pdf)
            pdfs+=("$path")
            ;;

        text/*|inode/x-empty|application/json|application/xml|application/x-shellscript)
            texts+=("$path")
            ;;

        application/zip\
        |application/x-7z-compressed\
        |application/vnd.rar\
        |application/x-rar\
        |application/x-tar\
        |application/gzip\
        |application/x-gzip\
        |application/x-bzip2\
        |application/x-xz\
        |application/zstd\
        |application/x-zstd\
        |application/x-lzma\
        |application/x-cpio\
        |application/x-arj\
        |application/x-xar\
        |application/vnd.ms-cab-compressed)
            archives+=("$path")
            ;;

        *)
            fallback+=("$path")
            ;;
    esac
done

# GUI applications return control to Yazi immediately.
if (( ${#images[@]} )); then
    detach swayimg "${images[@]}"
fi

if (( ${#media[@]} )); then
    detach mpv --player-operation-mode=pseudo-gui "${media[@]}"
fi

if (( ${#pdfs[@]} )); then
    detach zathura "${pdfs[@]}"
fi

if (( ${#office[@]} )); then
    detach libreoffice "${office[@]}"
fi

for path in "${rnotes[@]}"; do
    detach flatpak run com.github.flxzt.rnote "$path"
done

# Ask Yazi to extract archives.
for path in "${archives[@]}"; do
    ya pub extract --list "$path"
done

# Unknown file types use the system default application.
for path in "${fallback[@]}"; do
    detach xdg-open "$path"
done

# Keep Neovim in the foreground so Yazi waits for it.
if (( ${#texts[@]} )); then
    exec nvim -- "${texts[@]}"
fi
