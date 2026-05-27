local M = {}

local function gethostname()
	local hostname_cmd = "/bin/hostnamectl" .. " hostname"
	local f = io.popen(hostname_cmd)
	if f == nil then
		hl.notification.create({
			text = "can't read out of hostnamectl for reading hostname",
			timeout = 1200,
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
			timeout = 1200,
		})
		return "desktop"
	end
end

function M.MachineSpecificConfig(cfg_fn, cfg_table, device_name)
	if string.match(gethostname(), device_name) then
		hl.notification.create({
			text = device_name .. "specific config" .. debug.getinfo(hl.exec_cmd, "n").name
				or tostring(hl.exec_cmd)
				or "unkown" .. tostring(cfg_table),
			timeout = 1200,
		})
		cfg_fn(cfg_table)
	end
end

return M
