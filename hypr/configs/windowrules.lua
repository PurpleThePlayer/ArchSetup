-------------------
-- Window rules --
-------------------

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

-- Ideas you could add here:
-- * Keep video players awake:      idleinhibit = "fullscreen", match = { class = "mpv" }
--   (or for all fullscreen windows)
-- * Auto-fullscreen games:          fullscreen = true, match = { class = "^(gamescope)$" }
-- * No gaps when a window is alone on its workspace:
--   hl.window_rule({ match = { class = ".*" }, no_gaps_when_only = true })
--   (or set general.no_gaps_when_only globally in appearance.lua)
-- * Auto-group specific apps:       group = "always", match = { class = "^(firefox)$" }
-- * Always float a launcher/picker: float = true, match = { class = "^(org.pulseaudio...)$" }

---------------------
-- Workspace rules --
---------------------

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
