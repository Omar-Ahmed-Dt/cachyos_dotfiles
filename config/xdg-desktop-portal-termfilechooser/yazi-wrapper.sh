#!/usr/bin/env sh

set -eu

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

# Choose your terminal.
terminal="kitty"
yazi_cmd="yazi"

# Start from HOME when the application provides no valid location.
if [ -z "$path" ]; then
	path="$HOME"
fi

if [ "$save" = "1" ]; then
	# Save-file dialog.
	set -- --chooser-file="$out" "$path"
elif [ "$directory" = "1" ]; then
	# Directory chooser.
	cwd_out="${out}.cwd"
	set -- --chooser-file="$out" --cwd-file="$cwd_out" "$path"
elif [ "$multiple" = "1" ]; then
	# Multiple-file chooser.
	set -- --chooser-file="$out" "$path"
else
	# Single-file chooser.
	set -- --chooser-file="$out" "$path"
fi

"$terminal" -e "$yazi_cmd" "$@"

# For directory selection, return Yazi's final working directory.
if [ "$directory" = "1" ] && [ -s "${out}.cwd" ]; then
	cat "${out}.cwd" > "$out"
	rm -f "${out}.cwd"
fi
