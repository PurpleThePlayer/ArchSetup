----------------------
-- Hyprland entry   --
----------------------
-- This is the main config. Each section below lives in its own file
-- under configs/ so it stays easy to find and edit:
--   configs/appearance.lua  -> look & feel, animations, input
--   configs/keybinds.lua    -> all keybindings
--   configs/autostart.lua   -> apps started with the session
--   configs/windowrules.lua -> per-window and per-workspace rules
--   configs/monitors.lua    -> monitor setup
--
-- After editing, apply with: hyprctl reload

---------------------------
-- Environment Variables --
---------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

--------------------
-- Config files --
--------------------

require("configs/appearance")
require("configs/keybinds")
require("configs/autostart")
require("configs/windowrules")
require("configs/monitors")
