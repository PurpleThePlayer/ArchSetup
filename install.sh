#!/usr/bin/env bash
# Symlink this repo's config dirs into ~/.config/
# Usage: ./install.sh
# Existing files are backed up to ~/.config/<name>.bak before being replaced.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_config() {
    local name="$1"
    local src="$REPO/$name"
    local dst="$HOME/.config/$name"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak"
        echo "Backed up existing $dst -> $dst.bak"
    fi

    ln -sfn "$src" "$dst"
    echo "Linked $src -> $dst"
}

for app in hypr kitty swaync waybar wofi; do
    link_config "$app"
done

cat <<EOF

Done. Notes:
  - ly config lives in /etc (root-owned), link it once with:
      sudo ln -sf "$REPO/ly/config.ini" /etc/ly/config.ini
  - Restart Hyprland (or hyprctl reload) and waybar afterwards.
EOF
