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

local function autostart_desktop()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("kdeconnect-indicator & keepassxc")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("qs -c noctalia-shell")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("~/.config/hypr/scripts/start_idle_tool")
	hl.exec_cmd("xrdb -merge ~/.Xresources")

	hl.exec_cmd("~/.config/hypr/scripts/change_wallpaper_after_n.sh > ~/.cache/ch_wallpaper.log")
	hl.exec_cmd("udiskie -At")
	hl.exec_cmd("hyprpm reload >~/.hyprpm__output.txt")
	hl.exec_cmd("~/.config/hypr/scripts/hypr_blfilter_shader_man.py")
end

hl.on("hyprland.start", autostart_desktop)
