--------------------------
-- Appearance / sections --
--------------------------

hl.config({
    general = {
        gaps_in = 3,                     -- Gap between windows
        gaps_out = 5,                    -- Gap between windows and screen edges
        border_size = 3,                 -- Border thickness
        col = {
            active_border = {
                colors = { "rgb(100000)", "rgb(990000)", "rgb(100000)" },
                angle = 90,              -- Border color of focused windows
            },
            inactive_border = {
                colors = { "rgb(100000)", "rgb(990000)", "rgb(100000)" },
                angle = 180,             -- Border color of unfocused windows
            },
        },
        resize_on_border = true,         -- Resize windows by dragging their borders
        allow_tearing = false,           -- Could potentially break things if enabled
        layout = "dwindle",              -- Window tiling layout
    },

    dwindle = {
        preserve_split = true,           -- Keep the master/stack split consistent
    },

    decoration = {
        rounding = 10,                   -- Rounded window corners
        active_opacity = 0.9,            -- Transparency of focused windows
        inactive_opacity = 0.8,          -- Transparency of unfocused windows
        fullscreen_opacity = 1.0,        -- Transparency of fullscreen windows
        dim_inactive = true,             -- Darken unfocused windows
        dim_strength = 0.1,              -- Dimming strength, usually 0.0 to 1.0
        dim_special = 0.5,               -- Dimming strength for special windows, usually 0.0 to 1.0

        shadow = {
            enabled = true,              -- Show shadows around windows
            range = 10,                  -- Shadow spread
            render_power = 1,            -- Shadow sharpness
            color = "rgb(000000)",      -- Shadow color
        },

        blur = {
            enabled = true,              -- Blur background behind transparent windows
            new_optimizations = true,    -- Performance improvements for blur
            xray = true,                 -- Show blurred background through transparent windows
            ignore_opacity = true,       -- Apply blur equally regardless of window opacity
            size = 6,                    -- Blur radius
            passes = 2,                  -- Number of blur passes
            vibrancy = 0.1,              -- Color intensity in blur, usually 0.0 to 1.0
        },
    },

    master = {
        new_status = "master",           -- Use master layout behavior for new windows
    },

    misc = {
        disable_hyprland_logo = true,    -- Hide the Hyprland logo / mascot background
        disable_splash_rendering = true,  -- Hide the startup splash screen
        disable_autoreload = true,       -- Prevent automatic config reloads
    },

    input = {
        kb_layout = "se,us,jp",          -- Keyboard layouts in order
        kb_variant = ",,",               -- Variants for each layout entry
        kb_model = "",                   -- Keyboard model; usually leave empty
        kb_options = "",                 -- Extra XKB options
        kb_rules = "",                   -- XKB rules set

        numlock_by_default = true,       -- Turn Num Lock on at startup
        follow_mouse = 1,                -- 0=off, 1=follow cursor, 2=detach, 3=separate
        sensitivity = 0,                 -- -1.0 to 1.0, 0 means no modification

        touchpad = {
            natural_scroll = false,      -- Use normal scroll direction
        },
    },

    animations = {
        enabled = true,                  -- Enable or disable animations
    },
})

-- Animation curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- Ideas you could add to hl.config:
-- * Tighter feel when a window is alone on its workspace:
--   general.no_gaps_when_only = true
-- * Auto-group windows (e.g. terminals under one tab):
--   group.auto_group = true,  group.groupbar.enabled = true
-- * Wake the screen on any key/mouse activity:
--   misc.key_press_enables_dpms = true,  misc.mouse_move_enables_dpms = true
-- * Touchpad niceties:
--   input.touchpad.scroll_factor = 0.5,  input.touchpad.accel_profile = "flat"
-- * Smarter dwindle splitting:
--   dwindle.smart_split = true,  dwindle.smart_resizing = true
-- (Exact key names can change between Hyprland versions - check the wiki.)

