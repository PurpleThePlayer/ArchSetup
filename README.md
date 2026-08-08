# ArchSetup

Arch Linux dotfiles: Hyprland, Waybar, kitty, swaync, wofi and ly configs, plus an install guide (`ArchSetup.md`).

## Layout

```
ArchSetup/
├── hypr/                  # ~/.config/hypr   (Hyprland + hypridle/hyprlock/hyprpaper)
│   ├── hyprland.lua       # entry point: env vars + requires the files below
│   ├── configs/
│   │   ├── appearance.lua # look & feel, animations, input
│   │   ├── keybinds.lua   # all keybindings
│   │   ├── autostart.lua  # apps started with the session
│   │   ├── windowrules.lua# per-window + per-workspace rules
│   │   └── monitors.lua   # monitor setup
│   ├── hypridle.conf      # idle / screen-off / suspend
│   ├── hyprlock.conf      # lockscreen
│   └── hyprpaper.conf     # wallpapers
├── kitty/                 # ~/.config/kitty
├── swaync/                # ~/.config/swaync   (notifications)
├── waybar/                # ~/.config/waybar
├── wofi/                  # ~/.config/wofi     (launcher)
└── ly/                    # /etc/ly/config.ini (login manager)
```

## Install

```sh
git clone git@github.com:PurpleThePlayer/ArchSetup.git
cd ArchSetup
./install.sh                       # symlinks hypr, kitty, swaync, waybar, wofi
sudo ln -sf "$PWD/ly/config.ini" /etc/ly/config.ini   # one-time, root-owned
```

Config edits are picked up with `hyprctl reload` (Hyprland) or a waybar/kitty/etc. restart.

## Notes

- Requires Hyprland 0.56+ (Lua configs) and `waybar-git` (for workspace-click support on Lua IPC).
- Feature ideas and alternatives are kept as `-- Ideas` comments in the configs.

If you run into any issues or have any questions, feel free to reach out to me on discord: purpletheplayer
