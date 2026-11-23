-- Focus the window under the mouse when the mouse rests on it for a moment, with
-- a small flash of that window.
--
-- Hyprland has no delay for follow_mouse. So its own hover focus is on, a rule
-- blocks it, and the rule is lifted for a moment when the mouse rests. This way
-- Hyprland picks the window: menus, popups, bars and held buttons keep working.

local DELAY = 150 -- ms the mouse has to rest, keep it below 300 (see focus_hovered)
local REST = 8 -- px the mouse may move meanwhile
local POLL = 50 -- ms
local POLL_IDLE = 200 -- ms, after IDLE_AFTER without movement
local IDLE_AFTER = 3000
local FLASH = 120 -- ms, 0: no flash
local FLASH_TAG = "hover_flash"

local blocker = hl.window_rule({
	name = "hover_delay",
	match = { class = ".*" },
	no_follow_mouse = true,
})

hl.window_rule({
	name = "hover_flash",
	match = { tag = FLASH_TAG },
	-- focused, unfocused, fullscreen; fades with fadeSwitch (anims.lua)
	opacity = "0.75 0.75 1.0",
})

local function untag(window)
	-- nil: closed meanwhile
	if window.address then
		hl.dispatch(hl.dsp.window.tag({ tag = "-" .. FLASH_TAG, window = window }))
	end
end

-- a config reload during a flash
hl.timer(function()
	for _, window in ipairs(hl.get_windows({ tag = FLASH_TAG })) do
		untag(window)
	end
end, { timeout = 500, type = "oneshot" })

local function flash(window)
	if FLASH <= 0 or window.fullscreen ~= 0 or window.content_type == "game" then
		return
	end
	hl.dispatch(hl.dsp.window.tag({ tag = "+" .. FLASH_TAG, window = window }))
	hl.timer(function()
		untag(window)
	end, { timeout = FLASH, type = "oneshot" })
end

local function focus_hovered(pos)
	local before = hl.get_active_window()
	-- the usual case, nothing to do
	if before and Util.inside(before, pos) and not Util.floating_at(pos, before) then
		return
	end

	blocker:set_enabled(false)
	-- Same place, but Hyprland looks again what is under the mouse. It only
	-- focuses if the mouse really moved in the last 0.5 s.
	local ok, err = pcall(hl.dispatch, hl.dsp.cursor.move({ x = pos.x, y = pos.y }))
	blocker:set_enabled(true)
	if not ok then
		error(err, 0)
	end

	local after = hl.get_active_window()
	if after and not (before and before.address == after.address) then
		flash(after)
	end
end

local anchor = nil -- where the mouse rests
local rested = 0 -- ms
local moved = false -- since the last focus check
local interval = POLL

local timer
timer = hl.timer(function()
	local pos = hl.get_cursor_pos()
	if not pos then
		return
	end

	if not anchor or math.abs(pos.x - anchor.x) > REST or math.abs(pos.y - anchor.y) > REST then
		moved = anchor ~= nil
		anchor = pos
		rested = 0
	else
		rested = rested + interval
	end

	if moved and rested >= DELAY then
		moved = false
		if not Util.mouse_resize then
			focus_hovered(pos)
		end
	end

	interval = rested < IDLE_AFTER and POLL or POLL_IDLE
	timer:set_timeout(interval)
end, { timeout = POLL, type = "repeat" })
