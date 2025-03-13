local wezterm = require("wezterm")

local config = wezterm.config_builder()

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

config.color_scheme = "Gruvbox Dark (Gogh)"

config.font_size = 14.0

--config.window_decorations = "RESIZE"
config.macos_window_background_blur = 50
config.window_background_opacity = 0.75

--config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

--config.initial_rows = 30
--config.initial_cols = 150
config.window_close_confirmation = "NeverPrompt"

config.keys = {
	-- Split horizontally (below)
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Split vertically (right)
	{
		key = "e",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Close the current pane (unsplit)
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

local function center_window_once(window)
	wezterm.GLOBAL.windows_centered = wezterm.GLOBAL.windows_centered or {}

	local window_id = window:window_id() .. ""
	if wezterm.GLOBAL.windows_centered[window_id] then
		return
	end

	local screen = wezterm.gui.screens().active

	local width = screen.width * 1
	local height = screen.height * 0.33

	window:set_inner_size(width, height)

	local dimensions = window:get_dimensions()
	local x = (screen.width - dimensions.pixel_width) * 0.5
	local y = (screen.height - dimensions.pixel_height) * 0

	wezterm.GLOBAL.windows_centered[window_id] = true

	window:set_position(x, y)
end

wezterm.on("update-status", function(window)
	center_window_once(window)
end)

bar.apply_to_config(config)

return config
