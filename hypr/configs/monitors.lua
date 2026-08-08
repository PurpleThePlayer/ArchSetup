-------------
-- Monitors --
-------------

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

-- Ideas you could add here:
-- * Mirror the TV/second screen (your old config did this):
--   hl.monitor({ output = "HDMI-A-1", mirror = "DP-1" })
-- * Custom refresh rate:      mode = "2560x1440@165"
-- * Variable refresh rate:    vrr = true   (flicker-free VRR / adaptive sync)
-- * Cap framerate on a weak/second monitor: max_fps = 60
