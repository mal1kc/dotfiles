-- Mod key of every bind and gesture: "SUPER", or "ALT" for left alt
-- (right alt is AltGr on the tr layout)
MainMod = "SUPER"
-- second mod where a bind needs both, always the other one
AltMod = MainMod == "ALT" and "SUPER" or "ALT"

Util = require("util")

-- A require() of a missing file would stop this whole config (e.g. pulled but
-- not linked yet), so report it and go on: binds must always be loaded.
local function use(name)
	local ok, err = pcall(require, name)
	if not ok then
		hl.notification.create({
			text = "hypr config: can't load '" .. name .. "': " .. tostring(err),
			timeout = 8000,
			color = "rgba(255,0,0,1)",
		})
	end
end

use("binds")
use("gestures")

use("monitors")
use("env")
use("input")
use("look")
use("layout")
use("anims")
use("window_rules")
use("layer_rules")

use("autostart")
use("plugins")
