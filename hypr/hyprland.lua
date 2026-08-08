
---------------------------
-- Environment Variables --
---------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-------------------------------
-- sourcing / multiple files --
-------------------------------

require("configs/apperance")
require("configs/keybinds")

-- require("configs/autostart")
-- require("configs/windowrules")

---------------
-- Autostart --
---------------

hl.on("hyprland.start",function()
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


-----------------
-- windowrules --
-----------------

-- Pavucontrol / audio settings
hl.window_rule({
    name = "pavucontrol-settings", -- Name for this rule, useful for readability/debugging
    match = {class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"},
    float = true,                   -- Make the window floating
    size = { 705, 466 },            -- Set window size
    opacity = "0.7 0.5",            -- Active / inactive opacity
    move = { "100%-w-10", "40" },   -- Position near the top-right-ish area
})

hl.window_rule({match = {class = "^(steam)$"}, workspace = "4 silent"})
hl.window_rule({match = {class = "^(spotify)$"}, workspace = "3 silent"})
hl.window_rule({match = {class = "^(discord)$"}, workspace = "3 silent"})


-- Prevent apps from sending maximize requests
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix weird empty XWayland floating windows that shouldn't steal focus
hl.window_rule({
    name = "xwayland-nofocus-fix",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_initial_focus = true,
})

--------------------
-- Workspac rules --
--------------------

for i = 1, 5 do
    hl.workspace_rule({workspace = tostring(i), monitor = "DP-1", default = (i == 1)})
end

--[[
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
]]

--------------
-- Monitors --
--------------

-- Main external monitor
hl.monitor({
    output = "DP-1",
    mode = "preferred",      -- Use the monitor's preferred resolution/refresh
    position = "auto-left",  -- Place this monitor to the left of the others
    scale = "auto",         -- Let Hyprland choose scaling automatically
})

-- Second monitor
hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",      -- Use the monitor's preferred resolution/refresh
    position = "auto-right", -- Place this monitor to the right of the others
    scale = "auto",         -- Let Hyprland choose scaling automatically
})

-- Fallback for any other connected monitor
hl.monitor({
    output = "",
    mode = "preferred",      -- Use the monitor's preferred resolution/refresh
    position = "auto-left",  -- Default placement if no specific rule matches
    scale = "auto",         -- Let Hyprland choose scaling automatically
})
