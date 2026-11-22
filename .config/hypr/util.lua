local M = {}

local function gethostname()
	local hostname_cmd = "/bin/hostnamectl" .. " hostname"
	local f = io.popen(hostname_cmd)
	if f == nil then
		hl.notification.create({
			text = "can't read out of hostnamectl for reading hostname",
			timeout = 3200,
			color = "rgba(255,0,0,1)",
		})
		return "desktop"
	end
	local hostname = f:read("*a") or ""
	f:close()
	hostname = string.gsub(hostname, "\n$", "")
	if string.len(hostname) > 0 then
		-- hl.notification.create({ text = "aa " .. hostname .. " aa", timeout = 3000 })
		return hostname
	else
		hl.notification.create({
			text = "can't read hostname via hostnamectl," .. " using 'desktop' for use default configurations",
			timeout = 3200,
			color = "rgba(255,0,0,1)",
		})
		return "desktop"
	end
end

local function contains_ci(haystack, needle)
	if not (haystack and needle) then
		return false
	end
	return string.find(string.lower(haystack), string.lower(needle), 1, true) ~= nil
end

-- "desktop" or "laptop", decided by ~/.local/bin/machine_type:
-- .this_is_<machine> in the dotfiles repo, else the hostname
local function get_machine()
	local script = (os.getenv("HOME") or "") .. "/.local/bin/machine_type"
	local exists = io.open(script)
	if exists then
		exists:close()
		local f = io.popen("'" .. script .. "' 2>&1")
		if f then
			-- the type is the last line, anything before it is a warning
			local out = string.gsub(f:read("*a") or "", "%s+$", "")
			f:close()
			local machine = string.match(out, "([^\n]*)$")
			local warning = string.match(out, "^(.*)\n[^\n]*$")
			if warning then
				hl.notification.create({
					text = warning .. ", using hostname",
					timeout = 8000,
					color = "rgba(255,0,0,1)",
				})
			end
			if machine == "desktop" or machine == "laptop" then
				return machine
			end
		end
	end
	-- not linked yet
	return contains_ci(gethostname(), "laptop") and "laptop" or "desktop"
end

M.machine = get_machine()

-- workspace that layout messages go to: an open scratchpad comes first
function M.layout_workspace()
	return hl.get_active_special_workspace() or hl.get_active_workspace()
end

-- is_array(t): true if t is a sequence (integer keys 1..n without holes)
local function is_array(t)
	if type(t) ~= "table" then
		return false
	end
	local n = 0
	for k in pairs(t) do
		if type(k) ~= "number" or k <= 0 or k % 1 ~= 0 then
			return false
		end
		n = n + 1
	end
	return #t == n
end

function M.MachineSpecificCfg(cfg_fn, cfg_table, device_name)
	if M.machine == string.lower(device_name) then
		if is_array(cfg_table) then
			cfg_fn(table.unpack(cfg_table))
		else
			cfg_fn(cfg_table)
		end
	end
end

return M
