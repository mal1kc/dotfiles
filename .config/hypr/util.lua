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
	if string.len(hostname) >= 0 then
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

local init_hostname = gethostname()

local function contains_ci(haystack, needle)
	if not (haystack and needle) then
		return false
	end
	return string.find(string.lower(haystack), string.lower(needle), 1, true) ~= nil
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
	if contains_ci(init_hostname, device_name) then
		if is_array(cfg_table) then
			cfg_fn(table.unpack(cfg_table))
		else
			cfg_fn(cfg_table)
		end
		hl.notification.create({
			text = init_hostname
				.. " specific config "
				.. (debug.getinfo(cfg_fn, "n").name or "unkown")
				.. "("
				.. "...)",
			timeout = 3200,
			color = "rgba(0,255,0,1)",
		})
	end
end

return M
