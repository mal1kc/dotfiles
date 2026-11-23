# mal1kc's dotfiles (laptop branch)

## about this config

this config is my main setup config for archlinux laptop experience, for personal use

> [!CAUTION]
> :zap: i forget to edit readme file every time i push to github. so old read commit messages for changes.
> :zap: i also forget to remove old unused tools configs be aware if you spot one notify me.
>
> wallpapers are randomly selected via fish script on startup from `~/Pictures/wallpapers` or `~/pictures/wallpapers` folder 
>
> these paths are not exists or has no images some apps are not work properly
> for learn about additional info about this check this [script](./.local/bin/ch_wallpaper.sh)

> [!WARNING]
> i prefer to write scripts for single use things mostly write and mostly used 1 time

## install and update

> [!CAUTION]
> :zap: keep this repo at `~/dotfiles`. `install.py` works from anywhere but these are hardcoded: [audio menu](./.config/selection_tool/audio.json), [network menu](./.config/selection_tool/network.json), [write_pkg_list.sh](./scripts/write_pkg_list.sh)
>
> :zap: every file is symlinked to the repo which runs `install.py`. don't run it from a second clone or a git worktree, your live configs will point to there. don't move or delete the repo after install, all links will be dead
>
> :zap: some configs have my home (`/home/mal1kc`) in them: hyprlock, hyprpaper, fnott sound, noctalia, gtk-2.0, wofi. change them if you are not me

> [!WARNING]
> first install also takes over kitty, mpv, tmux, btop, yazi and more, your files are moved to `.dotfiles_backups` (only last 3 backups are kept) use `--dry-run` before
>
> after a manual `git pull` new files are not linked until install, hyprland can fall back to us keyboard layout until then. use `./install.py update` or do it in one line

```sh
./install.py machine laptop          # or desktop, base or your own, once per machine
./install.py install --wayland       # and/or --x11, remembered for later
./install.py update                  # git pull, relink, remove dead links, reload hyprland
./install.py status                  # what is missing, wrong or dead
```

* `machine` creates `.this_is_<name>` in the repo (not tracked, only one of them). without one a machine name in the hostname decides, otherwise it is `base`
* `.config`, `.local` etc. in the repo root are the core, same on every machine. `machines/<name>/` mirrors `$HOME`, files in there win over core ones
* `machines/base/` works on any hardware: monitors, mouse, gpu and location are not set in it. it is a start for new machines

* `update` refuses if there are uncommitted changes (btop writes its own config, that counts too)
* [sys_settings](./sys_settings/) is not installed, needs root

### new machine

```sh
./install.py new work --from base    # or laptop, desktop, without --from the current one is copied
./install.py install --wayland --prune --reload
```

or install one first, try it, then make yours from it

```sh
./install.py machine laptop && ./install.py install --wayland
./install.py new work                # copy of laptop, this machine uses it now
./install.py install --prune --reload
```

then edit and commit `machines/work/`, other machines don't change

| file | what |
|--- |--- |
| `.config/hypr/machine.lua` | hyprland monitors and settings, loaded last so it can override everything |
| `.config/niri/machine.kdl` | same for niri |
| `.config/hypr/hypridle.conf` | what happens on idle (laptop suspends, others only notify) |
| `.local/bin/machine_autostart` | bar and other programs, for every compositor |
| `.config/fuzzel/fuzzel.ini`, `.config/hypr/hyprlock.conf`, `.config/kanata/config.kbd` | font size, lock screen, caps key timing |
| any other file | copy it there with the same path to change it only for that machine (e.g. `.config/foot/foot.ini`) |

> [!NOTE]
> `base` has no wallpaper changer or blue light filter (commented, needs your location), its bar is `ashell`
>
> machines don't follow `base` after they are created, `install` and `status` only tell which files are missing

<details>
<summary>keybinds, palette and notifications</summary>

### mod key

super everywhere, one line to change it to left alt

| | file | line |
|--- |--- |--- |
| hyprland | [.config/hypr/hyprland.lua](./.config/hypr/hyprland.lua) | `MainMod = "ALT"` |
| niri | [.config/niri/config.kdl](./.config/niri/config.kdl) | `mod-key "Alt"` |
| river-classic | [.config/river/classic](./.config/river/classic) | `mod=Alt` |
| i3 | [.config/i3/config](./.config/i3/config) | `set $mod Mod1` |

### palette and notifications

* `mod + P` command palette, own items go to [custom.json](./.config/selection_tool/custom.json) (i3 has its own [i3.json](./.config/selection_tool/i3.json))
* `mod + K` show keybinds (opens the bind file read only)
* `mod + N` notification list --> [notifs](./.local/bin/notifs), how long popups stay is in [fnott.ini](./.config/fnott/fnott.ini)

> [!NOTE]
> notification history is only in ram (`$XDG_RUNTIME_DIR`) and gone after logout

> [!WARNING]
> niri, river-classic and i3 follow hyprland binds but i mostly use hyprland, others are less tested
>
> master scroll, delayed hover focus + flash and gloview are only on hyprland, others don't have them
>
> `river` (0.4+) is not supported for now, only `river-classic`

</details>

## config and used system info table

| | |
|--- |--- |
| os : | archlinux x86_64  |
| user shell : | fish :fish: |
| window manager/compositor : | Hyprland (main), niri, river-classic, (x11) i3 |
| theme : | Arc-Dark [GTK-2/3] |
| icons : | Papirus-Dark [GTK-2/3] |
| font : | Iosevka (most used) , Hack Nerd Font, Fira Code |
| term emulator: | (wayland) foot,(x11) kitty |

<details>
<summary>about files and folders</summary>
  
  > [!NOTE]
  > feel free to ask questions to me  about files & folders

</details>

<details>
<summary>programs i use</summary>

### programs 

* file manager : nautilus , pcmanfm , nnn
* media-player : mpv
* browser : firefox , librewolf
* text/code editor : nvim + neovide --> [configs for nvim is are here](https://github.com/mal1kc/nvim-config)
* color theme generator : wallust
* wallpaper daemon : awww
* screenshot utility : grim + slurp + [my screenshot script](./.local/bin/screenshot)
* launcher : fuzzel
* notification-daemon : swaync(Desktop) /  fnott (laptop)
* [other apps lists are here](./dotfiles_installers/) 

</details>

### images gallery

screenshot are in different branch 

> [!CAUTION]
> :zap: not up to date, screenshots are 1+ years old. they don't show current config (ashell, scrolling layout, niri etc.)

![screenshot0](../dotfiles_screenshots/laptop_screenshot1.png)
<br>
![screenshot1](../dotfiles_screenshots/laptop_screenshot2.png)
<br>
![screenshot2](../dotfiles_screenshots/laptop_screenshot3.png)
<br>
![screenshot3](../dotfiles_screenshots/laptop_screenshot4.png)
<br>
