--------------------
-- Autostart apps --
--------------------

-- Runs once when Hyprland starts. Apps listed here are part of the session.
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("fcitx5 -d --replace")

    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("nextcloud")

    hl.exec_cmd("kitty", { workspace = "1 silent" })
    hl.exec_cmd("zen-browser", { workspace = "2 silent" })
    -- hl.exec_cmd("notion-app", { workspace = "2 silent" })
    hl.exec_cmd("discord", { workspace = "3 silent" })
    hl.exec_cmd("spotify", { workspace = "3 silent" })
    hl.exec_cmd("steam", { workspace = "4 silent" })
    hl.exec_cmd("code", { workspace = "5 silent" })
end)

-- Ideas you could add here:
-- * Clipboard manager (cliphist):
--   yay -S cliphist wl-clipboard, then:
--   hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- copy history
--   and bind a key to: cliphist list | wofi --dmenu | cliphist decode | wl-copy
-- * Blue-light filter:  hl.exec_cmd("hyprsunset -t 3500")   (or wlsunset)
-- * Bluetooth tray:     hl.exec_cmd("blueman-applet")
-- * Animated wallpapers: replace hyprpaper with swww:
--   hl.exec_cmd("swww init && swww img ~/Pictures/wallpapers/calendar.png")
