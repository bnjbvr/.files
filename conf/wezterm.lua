local wezterm = require 'wezterm'

-- Start wezterm full-screen.
local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():toggle_fullscreen()
end)

local config = wezterm.config_builder()

-- Remove all window padding.
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}

config.color_scheme = 'cyberpunk'

-- Be able to read what's behind, but not be annoying.
config.window_background_opacity = 0.85

-- Default program run at start.
config.default_prog = { '/opt/homebrew/bin/zellij' }

-- Hide the tab bar; I'm using zellij :)
config.enable_tab_bar = false

-- Cool fonts
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 14

return config
