local wezterm = require 'wezterm'

function hostname()
    local handle = io.open("/etc/hostname", "r")
    local result = handle:read()
    handle:close()
    return result:gsub("\n$", "")
end

-- When set to true, will use a big screen font size.
local use_big_screen = false
local is_linux = false

local status, hostname = pcall(hostname)

wezterm.log_info("Status: " .. tostring(status) .. "/ Hostname: " .. hostname)

if status then
    use_big_screen = hostname == "archlinux"
    is_linux = hostname == "archlinux" or hostname == "karch"
end

-- Start wezterm full-screen.
local mux = wezterm.mux
wezterm.on("gui-startup", function()
    local _tab, _pane, window = mux.spawn_window {}
    if is_linux then
        -- Maximize the windows will make it large, rather than full-screen.
        window:gui_window():maximize()
    else
        -- This is nice on MacOS, but not on Linux.
        window:gui_window():toggle_fullscreen()
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

-- Cool fonts
config.font = wezterm.font 'FiraCode Nerd Font'

if use_big_screen then
    config.font_size = 18
else
    config.font_size = 14
end

config.leader = { key = 'b', mods = 'CTRL' }
config.keys = {
    -- Split vertically to the right with alt+n.
    {
        key = 'n',
        mods = 'ALT',
        action = wezterm.action.SplitPane {
            direction = 'Right',
            size = { Percent = 50 },
        },
    },

    -- Split horizontally to the bottom with alt+m.
    {
        key = 'm',
        mods = 'ALT',
        action = wezterm.action.SplitPane {
            direction = 'Down',
            size = { Percent = 50 },
        },
    },

    -- Open a new pane with alt+t.
    {
        key = 't',
        mods = 'ALT',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },

    -- Change focus using leader + vim shortcuts.
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },

    -- Another press of ctrl+b will send ctrl+b to the terminal.
    {
        key = 'b',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SendKey {
            key = 'b',
            mods = 'CTRL',
        },
    }
}

return config
