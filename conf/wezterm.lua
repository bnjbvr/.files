local wezterm = require 'wezterm'

function hostname()
    local handle = io.open("/etc/hostname", "r")
    local result = handle:read()
    handle:close()
    return result:gsub("\n$", "")
end

local use_big_screen = false
local is_linux = false

local status, hostname = pcall(hostname)

wezterm.log_info("Status: " .. tostring(status) .. "/ Hostname: " .. hostname)

if status then
    use_big_screen = hostname == "archlinux"
    is_linux = hostname == "archlinux"
end

-- Start wezterm full-screen.
local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  if is_linux then
      window:gui_window():maximize()
  else
      window:gui_window():toggle_fullscreen() -- nice on MacOS, not on Linux
  end
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
if is_linux then
    config.default_prog = { 'zellij' }
    config.window_decorations = "RESIZE"
else
    config.default_prog = { '/opt/homebrew/bin/zellij' }
end

-- Hide the tab bar; I'm using zellij :)
config.enable_tab_bar = false

-- Cool fonts
config.font = wezterm.font 'FiraCode Nerd Font'

if use_big_screen then
    config.font_size = 18
else
    config.font_size = 14
end

return config
