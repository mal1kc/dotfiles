---------------------------
---- BLUE LIGHT FILTER ----
---------------------------

-- Screen shader between sunset and sunrise, only on desktop.
-- Every config load resets screen_shader and the timers, so all of this has to
-- run at load and not in hl.on("hyprland.start").

if Util.machine ~= "desktop" then
	return
end

local LATITUDE = 40.92
local LONGITUDE = 29.92
local SHADER = (os.getenv("HOME") or "") .. "/.config/hypr/shaders/blueLightFilter.frag"
local CHECK_EVERY = 60 * 1000 -- ms

-- sunrise equation : https://en.wikipedia.org/wiki/Sunrise_equation
-- It is night when the nearest solar noon is further away than half of the
-- day's length, so neither time zone nor date changes matter.
local function is_night(now)
	local days = now / 86400 + 2440587.5 - 2451545.0 -- since J2000
	local n = math.floor(days - 0.0009 + LONGITUDE / 360 + 0.5)
	local mean_noon = n + 0.0009 - LONGITUDE / 360

	local anomaly = math.rad((357.5291 + 0.98560028 * mean_noon) % 360)
	local center = 1.9148 * math.sin(anomaly) + 0.02 * math.sin(2 * anomaly) + 0.0003 * math.sin(3 * anomaly)
	local ecliptic = math.rad((math.deg(anomaly) + center + 180 + 102.9372) % 360)
	local noon = mean_noon + 0.0053 * math.sin(anomaly) - 0.0069 * math.sin(2 * ecliptic)

	local latitude = math.rad(LATITUDE)
	local sin_d = math.sin(ecliptic) * math.sin(math.rad(23.4397))
	local cos_d = math.cos(math.asin(sin_d))
	local cos_w = (math.sin(math.rad(-0.833)) - math.sin(latitude) * sin_d) / (math.cos(latitude) * cos_d)
	-- out of range: sun never rises / never sets that day
	local half_day = math.deg(math.acos(math.max(-1, math.min(1, cos_w)))) / 360

	return math.abs(days - noon) > half_day
end

local enabled = false

local function update()
	local night = is_night(os.time())
	if night == enabled then
		return false
	end
	enabled = night
	hl.config({ decoration = { screen_shader = enabled and SHADER or "" } })
	return true
end

-- silent here: it would show up at every reload
update()

hl.timer(function()
	if update() then
		hl.notification.create({
			text = "Blue light filter " .. (enabled and "enabled" or "disabled"),
			icon = "info",
			timeout = 3000,
			font_size = 16,
		})
	end
end, { timeout = CHECK_EVERY, type = "repeat" })
