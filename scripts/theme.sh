#!/usr/bin/env bash
# Switch the color theme of sway, waybar, swaync, fuzzel, swaylock and foot.
#   theme.sh            show the current theme and the available ones
#   theme.sh gruvbox    switch to ~/.config/themes/gruvbox
#
# Palettes live in ~/.config/themes/<name> as key=rrggbb lines. Switching
# replaces every color of the current palette with the same slot of the new one,
# in place, so the config files stay normal files you can edit. Use palette
# colors when you edit them; other colors are left alone.
set -euo pipefail

DIR="$HOME/.config/themes"
CFG="$HOME/.config"
FILES=(
    "$CFG/sway/config"
    "$CFG/waybar/style.css"
    "$CFG/waybar/config.jsonc"
    "$CFG/swaync/style.css"
    "$CFG/fuzzel/fuzzel.ini"
    "$CFG/swaylock/config"
)

current=$(cat "$DIR/current")
themes=$(find "$DIR" -maxdepth 1 -type f ! -name current -printf '%f\n' | sort | tr '\n' ' ')

if [ $# -eq 0 ]; then
    echo "current: $current"
    echo "available: $themes"
    exit 0
fi

new=$1
[ -f "$DIR/$new" ] || { echo "no theme '$new' (available: $themes)" >&2; exit 1; }
[ "$new" = "$current" ] && { echo "already using $new"; exit 0; }

# Validate: same slots in both palettes, no duplicate values within one.
for t in "$current" "$new"; do
    dups=$(grep -v '^#' "$DIR/$t" | cut -d= -f2 | tr A-F a-f | sort | uniq -d)
    [ -z "$dups" ] || { echo "$t: duplicate colors: $dups" >&2; exit 1; }
done
if ! diff <(grep -v '^#' "$DIR/$current" | cut -d= -f1 | sort) \
          <(grep -v '^#' "$DIR/$new" | cut -d= -f1 | sort) >/dev/null; then
    echo "$current and $new don't define the same slots" >&2
    exit 1
fi

# Swap colors in one pass (no chained replacements). Matches #rrggbb, rrggbb
# and rrggbbaa (fuzzel/swaylock) and keeps the alpha suffix.
OLD="$DIR/$current" NEW="$DIR/$new" perl -pi -e '
    BEGIN {
        sub pal { my %p; open my $f, "<", shift or die; while (<$f>) { next if /^#/; chomp; my ($k, $v) = split /=/; $p{$k} = lc $v if $v } %p }
        my %o = pal($ENV{OLD}); my %n = pal($ENV{NEW});
        %map = map { $o{$_} => $n{$_} } keys %o;
    }
    s/(?<![0-9a-fA-F])([0-9a-fA-F]{6})(?=(?:[0-9a-fA-F]{2})?(?![0-9a-fA-F]))/exists $map{lc $1} ? $map{lc $1} : $1/ge;
' "${FILES[@]}"

# foot ships whole theme files; point its include at the new one.
sed -i "s|^include=~/.config/foot/themes/.*\.ini$|include=~/.config/foot/themes/$new.ini|" "$CFG/foot/foot.ini"

echo "$new" >"$DIR/current"

# Apply to what's running (swaylock and fuzzel read their config on each start).
swaymsg reload >/dev/null || true
pkill -SIGUSR2 -x waybar || true
swaync-client -rs >/dev/null 2>&1 || true
notify-send -t 2000 "Theme" "Switched to $new (new terminals after foot server restarts)"
echo "switched $current -> $new"
