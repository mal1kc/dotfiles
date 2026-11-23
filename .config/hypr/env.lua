-- desktop
Util.MachineSpecificCfg(hl.env, { "XDG_CURRENT_DESKTOP", "Hyprland" }, "desktop")
Util.MachineSpecificCfg(hl.env, { "XDG_SESSION_TYPE", "wayland" }, "desktop")
Util.MachineSpecificCfg(hl.env, { "XDG_SESSION_DESKTOP", "Hyprland" }, "desktop")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- TODO: make toggle while using nvidia card \
--        & manual or automatic
-- Nvidia specific settings
-- Util.MachineSpecificCfg(hl.env, { "LIBVA_DRIVER_NAME", "nvidia" }, "laptop")
-- Util.MachineSpecificCfg(hl.env, { "GBM_BACKEND", "nvidia-drm" }, "laptop")
-- Util.MachineSpecificCfg(hl.env, { "__GLX_VENDOR_LIBRARY_NAME", "nvidia" }, "laptop")
-- -- for va-api hardware accel
Util.MachineSpecificCfg(hl.env, { "NVD_BACKEND", "direct" }, "laptop")
