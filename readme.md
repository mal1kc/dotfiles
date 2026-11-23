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
./install.py machine laptop          # or desktop, once per machine
./install.py install --wayland       # and/or --x11, remembered for later
./install.py update                  # git pull, relink, remove dead links, reload hyprland
./install.py status                  # what is missing, wrong or dead
```

* `machine` creates `.this_is_laptop` / `.this_is_desktop` in the repo (not tracked, only one of them), without one hostname decides --> [machine_type](./.local/bin/machine_type)
* `machines/<laptop|desktop>/` mirrors `$HOME`, files in there win over shared ones
* `update` refuses if there are uncommitted changes (btop writes its own config, that counts too)
* [sys_settings](./sys_settings/) is not installed, needs root

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
