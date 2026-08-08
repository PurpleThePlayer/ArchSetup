--------------------
-- User variables --
--------------------

-- Modifiers
local modkey = "SUPER"   -- Main modifier
local mod1 = "SHIFT"     -- Movement modifier
local mod2 = "CTRL"      -- Change properties
local mod3 = "ALT"       -- Window modifier


-- Default Programs
local terminal = "kitty"
local file = "thunar"
local searchMenu = "pkmill wofi || wofi --show drun"
local browser = "zen-browser"
local editorText = "code"
local copyColor = "hyprpicker -a"
local waybar = "pkill waybar || waybar"

local screenshot = "hyprshot -m output"
local windowshot = "hyprshot -m window"
local cropsave = "hyprshot -m region"
local cropclipboard = "hyprshot -m region -m active --clipboard-only"

local notification = 'notify-send "I love Sven"'
local notifications = "swaync-client -t -sw"

-- Toggle floating for every window on the active workspace
-- (replacement for the old, deprecated "workspaceopt allfloat")
local function toggle_all_float()
    local ws = hl.get_active_workspace()
    local wins = hl.get_workspace_windows(ws)
    for _, w in ipairs(wins) do
        hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w }))
    end
end



--------------
-- Keybinds --
--------------

-- Apps
hl.bind(modkey .. " + W", hl.dsp.exec_cmd(waybar))                  -- Open or toggle Waybar
hl.bind(modkey .. " + E", hl.dsp.exec_cmd(editorText))              -- Open text editor
hl.bind(modkey .. " + T", hl.dsp.exec_cmd(terminal))                -- Open terminal
hl.bind(modkey .. " + P", hl.dsp.exec_cmd(copyColor))               -- Pick a color with hyprpicker

hl.bind(modkey .. " + S", hl.dsp.exec_cmd("steam"))                 -- Launch Steam
hl.bind(modkey .. " + D", hl.dsp.exec_cmd(searchMenu))              -- Open app launcher
hl.bind(modkey .. " + F", hl.dsp.exec_cmd(file))                    -- Open file manager
hl.bind(modkey .. " + L", hl.dsp.exec_cmd("hyprlock"))             -- Lock the screen

hl.bind(modkey .. " + B", hl.dsp.exec_cmd(browser))                -- Open browser
hl.bind(modkey .. " + N", hl.dsp.exec_cmd("notion-app"))           -- Open Notion
hl.bind(modkey .. " + grave", hl.dsp.exec_cmd(notifications))      -- Open notification center
hl.bind(mod3 .. " + grave", hl.dsp.exec_cmd(notification))         -- Send test notification

-- Screenshots
hl.bind("print", hl.dsp.exec_cmd(cropsave))                         -- Take a region screenshot and save it
hl.bind(modkey .. " + print", hl.dsp.exec_cmd(screenshot))         -- Take an output screenshot
hl.bind(mod2 .. " + print", hl.dsp.exec_cmd(cropclipboard))        -- Take a region screenshot to clipboard
hl.bind(mod3 .. " + print", hl.dsp.exec_cmd(windowshot))           -- Take a window screenshot

-- Windows | mod3
hl.bind(mod3 .. " + Q", hl.dsp.window.close())                      -- Close active window
hl.bind(mod3 .. " + SHIFT + Q", hl.dsp.exit())                     -- Exit Hyprland
hl.bind(mod3 .. " + F", hl.dsp.window.fullscreen())                       -- Toggle fullscreen
hl.bind(mod3 .. " + P", hl.dsp.window.pseudo())                            -- toggle pseudotile
hl.bind(mod3 .. " + G", hl.dsp.group.toggle())              -- Toggle window group
hl.bind(mod3 .. " + SHIFT + G", hl.dsp.group.next()) -- Cycle group window
hl.bind(mod3 .. " + SPACE", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating
hl.bind(mod3 .. " + SHIFT + SPACE", toggle_all_float)                    -- Toggle floating for all windows



hl.bind(mod3 .. " + C", hl.dsp.window.center())                    -- Center focused window
hl.bind(mod3 .. " + CAPS_LOCK", hl.dsp.window.cycle_next())        -- Cycle to next window in group
hl.bind(mod3 .. " + T", hl.dsp.window.alter_zorder({mode = "top"}))              -- Bring window to top

-- Move window
hl.bind(mod3 .. " + " .. mod1 .. " + left", hl.dsp.window.move({ direction = "l" }))  -- Move window left
hl.bind(mod3 .. " + " .. mod1 .. " + right", hl.dsp.window.move({ direction = "r" })) -- Move window right
hl.bind(mod3 .. " + " .. mod1 .. " + up", hl.dsp.window.move({ direction = "u" }))    -- Move window up
hl.bind(mod3 .. " + " .. mod1 .. " + down", hl.dsp.window.move({ direction = "d" }))  -- Move window down

-- Focus
hl.bind(mod3 .. " + left", hl.dsp.focus({ direction = "left" }))   -- Focus left window
hl.bind(mod3 .. " + right", hl.dsp.focus({ direction = "right" }))  -- Focus right window
hl.bind(mod3 .. " + up", hl.dsp.focus({ direction = "up" }))         -- Focus upper window
hl.bind(mod3 .. " + down", hl.dsp.focus({ direction = "down" }))     -- Focus lower window

hl.bind(mod3 .. " + H", hl.dsp.focus({ direction = "left" }))       -- Vim-style focus left
hl.bind(mod3 .. " + J", hl.dsp.focus({ direction = "down" }))       -- Vim-style focus down
hl.bind(mod3 .. " + K", hl.dsp.focus({ direction = "up" }))         -- Vim-style focus up
hl.bind(mod3 .. " + L", hl.dsp.focus({ direction = "right" }))      -- Vim-style focus right

-- Resize
hl.bind(mod3 .. " + " .. mod2 .. " + left", hl.dsp.window.resize({ x = -50, y = 0 }), { repeating = true })  -- Resize left
hl.bind(mod3 .. " + " .. mod2 .. " + right", hl.dsp.window.resize({ x = 50, y = 0 }), { repeating = true })   -- Resize right
hl.bind(mod3 .. " + " .. mod2 .. " + up", hl.dsp.window.resize({ x = 0, y = -50 }), { repeating = true })     -- Resize up
hl.bind(mod3 .. " + " .. mod2 .. " + down", hl.dsp.window.resize({ x = 0, y = 50 }), { repeating = true })    -- Resize down

-- Mouse drag window move/resize
hl.bind(mod3 .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })   -- Drag to move window
hl.bind(mod3 .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Drag to resize window

-- Special workspace (scratchpad)
hl.bind(modkey .. " + tab", hl.dsp.workspace.toggle_special())                 -- Toggle special workspace
hl.bind(mod3 .. " + " .. mod1 .. " + tab", hl.dsp.window.move({ workspace = "special" })) -- Move to special workspace
hl.bind(mod3 .. " + tab", hl.dsp.window.move({ workspace = "special" }), { silent = true }) -- Move silently to special workspace

-- Workspace switching
hl.bind(modkey .. " + right", hl.dsp.focus({ workspace = "e+1" }))    -- Next workspace
hl.bind(modkey .. " + left", hl.dsp.focus({ workspace = "e-1" }))     -- Previous workspace
hl.bind(modkey .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" })) -- Next workspace with wheel
hl.bind(modkey .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))   -- Previous workspace with wheel

for i = 1, 10 do
    local key = tostring(i % 10)                                     -- Convert 10 -> 0 for workspace 10

    hl.bind(modkey .. " + " .. key, hl.dsp.focus({ workspace = i })) -- Go to workspace i
    hl.bind(mod3 .. " + " .. mod1 .. " + " .. key, hl.dsp.window.move({ workspace = i })) -- Move window to workspace i
    hl.bind(mod3 .. " + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))    -- Move window silently
end


-- Volume / brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })   -- Volume up
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })   -- Volume down
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })        -- Toggle mute
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })   -- Toggle mic mute
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })                        -- Brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })                      -- Brightness down

-- Media keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })      -- Next track
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- Pause/play
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })  -- Play/pause
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })    -- Previous track

-- Ideas you could add here:
-- * Mouse side buttons:
--   hl.bind(modkey .. " + mouse:275", hl.dsp.focus({ workspace = "e-1" }))   -- back button
--   hl.bind(modkey .. " + mouse:276", hl.dsp.focus({ workspace = "e+1" }))   -- forward button
-- * Named scratchpads (multiple special workspaces):
--   hl.bind(modkey .. " + i", hl.dsp.workspace.toggle_special("magic"))     -- e.g. notes
--   hl.bind(modkey .. " + u", hl.dsp.workspace.toggle_special("music"))     -- e.g. player
--   (the unnamed togglespecial() above keeps using the default scratchpad)
-- * Layout plugins (hyprland-plugins):
--   - hyprgrass: touchpad gestures (pinch to switch workspaces, swipe up for scratchpad)
--   - hyprscroller / hyprsplit: scroll or split layouts
--   installed via hyprpm, then bound with their own dispatchers
-- * Audio helpers:
--   hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctld shift"))   -- switch player target
