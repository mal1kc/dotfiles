-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("kdeconnect-indicator & keepassxc")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("~/.local/bin/notifs watch")
	-- hl.exec_cmd("pcmanfm -d")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("~/.config/hypr/scripts/start_idle_tool")
	hl.exec_cmd("xrdb -merge ~/.Xresources")
	hl.exec_cmd("hyprpm reload >~/.hyprpm__output.txt")
	-- bar and everything only this machine starts
	hl.exec_cmd("~/.local/bin/machine_autostart hyprland")
end)
