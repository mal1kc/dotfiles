-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local function desktop_monitors()
	local monitor1 = "DP-1"
	local monitor2 = "DP-2"

	hl.monitor({
		output = monitor1,
		mode = "2560x1440@180",
		position = "0x0",
		scale = 1,
	})

	hl.monitor({
		output = "DP-2",
		mode = "1600x900@60",
		position = "2560x300",
		scale = 1,
	})

	hl.workspace_rule({
		workspace = "1",
		monitor = monitor1,
	})

	hl.workspace_rule({
		workspace = "2",
		monitor = monitor2,
	})
end

local function laptop_monitors()
	local monitor1 = "eDP-1"
	local monitor2 = "HDMI-A-1"

	hl.monitor({
		output = monitor1,
		mode = "1920x1080",
		position = "0x0",
		scale = 1,
	})

	hl.workspace_rule({
		workspace = "1",
		monitor = monitor1,
	})
end

Util.MachineSpecificConfig(desktop_monitors, nil, "desktop_monitors")
Util.MachineSpecificConfig(laptop_monitors, nil, "laptop")
