-- Master pinned on the left, stack on the right that scrolls up/down to keep
-- the focused window in view. Returns the layout name for workspace rules.
--
-- The stack scrolls vertically because windows placed past the left/right edge
-- would show up on the monitor next to it.
-- Limit: Lua layouts don't get mouse resizes, use SUPER + minus / asterisk.

local NAME = "lua:masterscroll"
local VISIBLE = 2 -- stack windows on screen
local WIDTHS = { 0.4, 0.5, 0.6, 0.7, 0.8 } -- steps of colresize +conf/-conf

local states = {} -- workspace name -> { mfact, top, master }

local function target_id(target)
	local window = target.window
	return window and tostring(window.stable_id) or ("target" .. target.index)
end

local function state_of(ctx)
	local name = ""
	for _, target in ipairs(ctx.targets) do
		local window = target.window
		if window and window.workspace then
			name = window.workspace.name or ""
			break
		end
	end
	states[name] = states[name] or { mfact = 0.6, top = 1 }
	return states[name]
end

-- master target, stack targets, index of the focused one in the stack
local function arrange(ctx, state)
	local master = ctx.targets[1]
	for _, target in ipairs(ctx.targets) do
		if target_id(target) == state.master then
			master = target
			break
		end
	end
	if not master then
		return nil, {}, nil
	end

	local stack, focused = {}, nil
	local master_id = target_id(master)
	for _, target in ipairs(ctx.targets) do
		if target_id(target) ~= master_id then
			stack[#stack + 1] = target
			if target.window and target.window.active then
				focused = #stack
			end
		end
	end
	return master, stack, focused
end

local function recalculate(ctx)
	local state = state_of(ctx)
	local master, stack, focused = arrange(ctx, state)
	if not master then
		return
	end
	if #stack == 0 then
		master:place(ctx.area)
		return
	end

	local rows = math.min(#stack, VISIBLE)
	local top = state.top
	if focused and focused < top then
		top = focused
	elseif focused and focused > top + rows - 1 then
		top = focused - rows + 1
	end
	state.top = math.max(1, math.min(top, #stack - rows + 1))

	master:place(ctx:split(ctx.area, "left", state.mfact))

	local side = ctx:split(ctx.area, "right", 1 - state.mfact)
	local height = side.h / rows
	for i, target in ipairs(stack) do
		target:place({
			x = side.x,
			y = side.y + (i - state.top) * height,
			w = side.w,
			h = height,
		})
	end
end

local function next_width(current, step)
	if step > 0 then
		for _, width in ipairs(WIDTHS) do
			if width > current + 0.001 then
				return width
			end
		end
		return WIDTHS[#WIDTHS]
	end
	for i = #WIDTHS, 1, -1 do
		if WIDTHS[i] < current - 0.001 then
			return WIDTHS[i]
		end
	end
	return WIDTHS[1]
end

local function layout_msg(ctx, msg)
	local state = state_of(ctx)
	local command, arg = msg:match("^(%S+)%s*(%S*)")

	if command == "colresize" then
		if arg == "+conf" then
			state.mfact = next_width(state.mfact, 1)
		elseif arg == "-conf" then
			state.mfact = next_width(state.mfact, -1)
		elseif tonumber(arg) then
			state.mfact = math.max(0.2, math.min(0.8, tonumber(arg)))
		end
	elseif command == "promote" then
		-- focused stack window becomes master; on the master, swap it with
		-- the first stack window
		local _, stack, focused = arrange(ctx, state)
		local target = stack[focused or 1]
		if target then
			state.master = target_id(target)
		end
	end
	-- "refresh" and scrolling-only messages: Hyprland recalculates anyway
	return true
end

hl.layout.register("masterscroll", {
	recalculate = recalculate,
	layout_msg = layout_msg,
})

-- focus changes don't recalculate a layout by themselves
hl.on("window.active", function(window)
	local workspace = window and not window.floating and window.workspace
	if not workspace or workspace.tiled_layout ~= NAME then
		return
	end
	-- only if the message will reach that workspace
	local active = Util.layout_workspace()
	if active and active.name == workspace.name then
		hl.dispatch(hl.dsp.layout("refresh"))
	end
end)

return NAME
