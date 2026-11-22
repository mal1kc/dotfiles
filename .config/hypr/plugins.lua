-- TODO: manual review — plugin section ''. The new Lua API exposes plugins via hl.plugin.<name>(...) — wire up per the plugin's docs.
--[[
  -- hyprwinwrap { ... }
  -- Desktop
  -- hyprbars { ... }
]]

-- all windows
hl.bind(MainMod .. " + TAB", hl.plugin.gloview.toggle)
hl.bind(MainMod .. " + SHIFT + TAB", hl.plugin.gloview.desktop)
hl.bind(MainMod .. " + CTRL + TAB", hl.plugin.gloview.allworkspaces)

hl.bind(MainMod .. " + less", hl.plugin.gloview.prev)

-- SUPER + 1..7 are in binds.lua; inside the overview plain 1..0 work (key_workspace)

hl.config({
	plugin = {
		gloview = {
			layout = "natural",
			gap = 34,
			padding = 80,
			padding_top = 40,
			padding_bottom = 70,
			max_scale = 1.0,
			preview_filter = "box4",
			duration = 120,
			preview_round = 12,
			blur = 1,

			switch_animation = 1,
			switch_duration = 20,
			move_animation = 1,
			move_duration = 20,

			anchor = "left",
			strip_offset = 0,
			strip_height = 150,
			strip_margin = 22,
			strip_gap = 18,
			strip_card_round = 10,

			focus_follows_mouse = 1,
			scroll_switches_workspace = 1,
			passthrough_keys = 1,
			exit_on_click = 1,
			exit_on_switch = 0,

			key_close = "escape",
			key_next_workspace = "tab",
			key_prev_workspace = "shift+tab",
			key_activate = "enter",
			key_close_window = "d",
			key_left = "left",
			key_right = "right",
			key_up = "up",
			key_down = "down",
			key_desktop = "shift",
			key_all_workspaces = "a",
			key_workspace = "1,2,3,4,5,6,7,8,9,0",

			show_all_workspaces = 1,
			show_empty = 1,
			dynamic_workspaces = 1,
			autodelete_empty = 1,
			show_workspace_labels = 1,
			show_window_labels = 1,
			show_special = 0,
			strip_all_card = 1,
			drag_to_swap = 1,
			switch_on_drop = 0,
			switch_on_new_workspace = 1,

			hide_top_layers = 0,
			hide_overlay_layers = 0,
			above_namespaces = "",
			debug_logs = 0,

			select_border_size = 3,
			select_border = 0xf066ccff,
			close_button_color = 0xe6e23b3b,
			backdrop_color = 0x73070a10,
			strip_band_color = 0x24ffffff,
			strip_card_color = 0x3a0e131c,
			strip_active_color = 0x4d1c2c44,
			strip_active_border = 0xf0ffffff,
			strip_hover_border = 0x80ffffff,
			strip_active_border_size = 2,
			strip_hover_border_size = 2,
			strip_plus_color = 0xd0eef4ff,
			preview_bg = 0xff14181f,
			shadow_color = 0x70000000,
			hover_border = 0xf0ffffff,
			hover_border_size = 3,
		},
	},
})
