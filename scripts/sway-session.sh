#!/usr/bin/env bash
# Save open programs + their workspaces before exiting sway, and relaunch them
# on the next login.
#   sway-session.sh save      write ~/.cache/sway-session.json
#   sway-session.sh restore   relaunch saved programs, move them to their workspaces
set -euo pipefail

FILE="${XDG_CACHE_HOME:-$HOME/.cache}/sway-session.json"
WAIT=15 # seconds to wait for each program's window

save() {
    local tree focused
    tree=$(swaymsg -t get_tree)
    focused=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

    # One entry per process (a browser with 3 windows is one process), except
    # foot: all footclient windows share the server's pid, so keep each window.
    # The drop-down terminal is skipped; its key recreates it on demand.
    printf '%s' "$tree" | jq -c '
        recurse(.nodes[]?, .floating_nodes[]?)
        | select(.type == "workspace" and .name != "__i3_scratch") as $ws
        | $ws | recurse(.nodes[]?, .floating_nodes[]?)
        | select(.pid? and (.type == "con" or .type == "floating_con"))
        | select(.nodes == [] and .floating_nodes == [])
        | {pid, con: .id, ws: $ws.name, id: (.app_id // .window_properties.class // "")}
        | select(.id != "dropterm")
    ' | jq -s 'unique_by(if .id == "foot" or .id == "footclient" then "con\(.con)" else "pid\(.pid)" end)' |
    jq -c '.[]' | while read -r win; do
        pid=$(jq -r .pid <<<"$win")
        [ -r "/proc/$pid/cmdline" ] || continue
        # cmdline is NUL-separated; turn it into a JSON array of args
        cmd=$(tr '\0' '\n' <"/proc/$pid/cmdline" | jq -R . | jq -s .)
        [ "$cmd" = "[]" ] && continue
        # A window of the foot server reopens as a new footclient window
        jq -e 'any(.[]; startswith("--server"))' <<<"$cmd" >/dev/null && cmd='["footclient"]'
        jq -c --argjson cmd "$cmd" '{id, ws, cmd: $cmd}' <<<"$win"
    done | jq -s --arg focused "$focused" '{focused: $focused, windows: .}' >"$FILE"

    notify-send -t 1500 "Session saved" "$(jq '.windows | length' "$FILE") programs"
}

con_ids() {
    swaymsg -t get_tree | jq -r --arg id "$1" '
        recurse(.nodes[]?, .floating_nodes[]?)
        | select(.pid? and ((.app_id // .window_properties.class // "") == $id))
        | .id'
}

restore() {
    [ -f "$FILE" ] || exit 0
    # Move the file away first so a crash/relogin never restores twice.
    local file="$FILE.restoring"
    mv "$FILE" "$file"
    sleep 2 # let sway, waybar and the session target settle

    jq -c '.windows[]' "$file" | while read -r win; do
        id=$(jq -r .id <<<"$win")
        ws=$(jq -r .ws <<<"$win")
        mapfile -t cmd < <(jq -r '.cmd[]' <<<"$win")
        # Electron apps rewrite argv into one space-joined string; split it back.
        if [ "${#cmd[@]}" -eq 1 ] && [[ "${cmd[0]}" == *" "* ]] && [ ! -x "${cmd[0]}" ]; then
            read -ra cmd <<<"${cmd[0]}"
        fi
        command -v "${cmd[0]}" >/dev/null 2>&1 || [ -x "${cmd[0]}" ] || continue

        before=$(con_ids "$id")
        setsid -f "${cmd[@]}" >/dev/null 2>&1 </dev/null

        # Wait for a window of this app that wasn't there before, then move it.
        for _ in $(seq $((WAIT * 4))); do
            new=$(comm -13 <(sort <<<"$before") <(con_ids "$id" | sort) | head -1)
            if [ -n "$new" ]; then
                swaymsg "[con_id=$new] move container to workspace \"$ws\"" >/dev/null
                break
            fi
            sleep 0.25
        done
    done

    focused=$(jq -r .focused "$file")
    [ -n "$focused" ] && swaymsg "workspace --no-auto-back-and-forth \"$focused\"" >/dev/null
    rm -f "$file"
}

case "${1:-}" in
    save) save ;;
    restore) restore ;;
    *) echo "usage: $0 save|restore" >&2; exit 1 ;;
esac
