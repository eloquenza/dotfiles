-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choice
------------------------------------------------------

config.color_scheme = 'Selenized Dark (Gogh)'

config.default_prog = { '/bin/fish', '-l' }

-- disabled for now due to an issue in the wayland renderer with fractional scaling.
config.enable_wayland = false

config.font = wezterm.font("Fira Code Nerd Font", { weight = 450 })
config.font_size = 14.0

------------------------------------------------------
-- and finally, return the configuration to wezterm
return config
