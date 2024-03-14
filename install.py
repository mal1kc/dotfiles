#!/usr/bin/env python
import os
import shutil
import subprocess
import sys
import argparse
import tempfile

from datetime import datetime
from pathlib import Path
from typing import List, Callable, Any

DRY_RUN: bool = True
VERBOSE: bool = False

HOME_DIR: Path = Path.home()

DOTFILES_DIR: Path = HOME_DIR / "dotfiles"
BACKUPS_DIR: Path = HOME_DIR / ".dotfiles_backups"


INSTALLER_DIR: Path | None = DOTFILES_DIR / "dotfiles_installers"

BACKUP_TMP_DIR: Path = Path(tempfile.mkdtemp())

DOTFILE_LIST: list[os.PathLike] = [
    Path(config)
    for config in [
        ".doom.d",
        ".local/bin",
        ".local/share/applications",
        ".Xresources",
        ".bashrc",
        ".emacs-profiles.el",
        ".gitconfig",
        ".gitignore",
        ".gtkrc-2.0",
        ".inputrc",
        ".zshrc",
    ]
    + [
        f".config/{dotconfig}"
        for dotconfig in [
            "bat",
            "dunst",
            "fish",
            "gtk-3.0",
            "kitty",
            "mpv",
            "my_extra_configs",
            "nnn",
            "nsxiv",
            "pcmanfm",
            "systemd",
            "tmux",
            "wal",
            "zathura",
            "zsh",
            "mimeapps.list",
            "user-dirs.dirs",
        ]
    ]
]


IGNORE_FILES: List[os.PathLike] = [
    Path(ignr_config)
    for ignr_config in [
        ".git",
        ".gitignore",
        ".gitmodules",
        ".firefox_scripts_configs",
        ".pre-commit-config.yaml",
        "scripts",
        "dotfiles_installers",
        "pkg_list.txt",
        "nix_profile_pkg_list.txt",
        "install.py",
        "readme.org",
    ]
]

# create a list of dotfiles without the ignored files and not existing files/directories

DOTFILES = [dfile for dfile in DOTFILE_LIST if dfile not in IGNORE_FILES]


IGNORE_SCRIPTS: List[str] = ["archlinux_and_aur_install.sh"]  # TODO: fix script

OTHER_DOTFILES: dict[str, List[os.PathLike]] = {
    "x11": [
        Path(x11config)
        for x11config in [
            ".xinitrc",
            ".xprofile",
            ".config/picom.conf",
            ".config/rofi",
            ".config/i3",
        ]
    ],
    "wayland": [
        Path(waylandconfig)
        for waylandconfig in [
            ".config/foot",
            ".config/hypr",
            ".config/river",
            ".config/waybar",
            ".config/wofi",
        ]
    ],
}


def write_stderr(msg: str) -> None:
    sys.stderr.write(msg + "\n")
    sys.stderr.flush()


def write_stdout(msg: str) -> None:
    sys.stdout.write(msg + "\n")
    sys.stdout.flush()


def do_job(
    msg: str,
    callable: Callable,
    callable_args: dict[str, Any],
) -> Any:
    """
    if dry_run is False, do the job with the callable and the callable_args
    else print the msg and the callable_args
    """
    global DRY_RUN
    global VERBOSE
    if DRY_RUN:
        write_stdout(f"[Dry Run] {msg} with call of {callable} with {callable_args}")
        return None
    else:
        if VERBOSE:
            write_stdout(
                f"[Verbose] {msg} with call of {callable} with {callable_args}"
            )
        return callable(**callable_args)


def check_dirs() -> None:
    for directry in [DOTFILES_DIR, INSTALLER_DIR]:
        if not directry.exists():
            write_stderr(f"Error: {directry} does not exist.")
            sys.exit(1)
    if not BACKUPS_DIR.exists():
        BACKUPS_DIR.mkdir()


def create_archive(
    archive_name: str,
    archive_store_folder: Path,
    dir_to_archive: Path,
    arch_format: str = "gztar",
) -> Path:
    """
    Create a archive of files.
    """
    global DRY_RUN

    files = [f for f in dir_to_archive.iterdir()]

    archive_file = (
        archive_store_folder
        / f"{archive_name}_{datetime.now().strftime('%Y_%m_%d_%H_%M_%S')}__{len(files)}"
    )
    for possible_archive in archive_store_folder.iterdir():
        if possible_archive.name.startswith(archive_file.name):
            write_stderr(f"Warning: Archive {possible_archive} already exists.")
            exit(1)

    return do_job(
        f"Archive {archive_name} created",
        shutil.make_archive,
        {
            "base_name": str(archive_file),
            "format": arch_format,
            "root_dir": HOME_DIR,
            "base_dir": dir_to_archive,
            "dry_run": DRY_RUN,
        },
    )


def install_dotfile(dfile: os.PathLike, do_backup: bool = True) -> bool:
    """
    Install a dotfile (symlink) and create a backup if the file already exists.
    """
    # TODO: still creates self links dirs why??
    src = DOTFILES_DIR / dfile
    dst = HOME_DIR / dfile

    if not src.exists():
        write_stderr(f"Error: {dfile} not found in dotfiles directory.")
        return False

    if dst.exists():
        if not dst.is_symlink():
            if do_backup:
                backup_dotfile(dfile)
            if dst.is_dir():
                for subfile in dst.iterdir():
                    if not install_dotfile(subfile.relative_to(HOME_DIR), do_backup):
                        write_stderr(f"failed during installation of {subfile}")
            else:
                do_job(
                    f"File {dst} removed",
                    os.remove,
                    {"path": dst},
                )
    if src.is_dir():
        do_job(
            f"Directory {dst} created",
            Path.mkdir,
            {
                "self": dst,
                "parents": True,
                "exist_ok": True,
            },
        )
        for subfile in src.iterdir():
            if not install_dotfile(subfile.relative_to(DOTFILES_DIR), do_backup):
                write_stderr(f"failed during installation of {subfile}")
        return True
    do_job(
        f"Symlink {dfile} created",
        os.symlink,
        {
            "src": src.resolve(),
            "dst": dst.resolve(),
        },
    )
    return True


def install_scripts() -> None:
    """
    runs executables with arg 'install' from  INSTALLER_DIR
    """

    if not INSTALLER_DIR:
        return

    scripts = [
        script
        for script in INSTALLER_DIR.iterdir()
        if script.is_file() and script.stat().st_mode & 0o111
    ]

    for script in scripts:
        if script in IGNORE_SCRIPTS:
            write_stdout(f"Script {script} ignored")
            continue

        do_job(
            f"Script {script} installed",
            subprocess.run,
            {"args": [INSTALLER_DIR / script, "install"], "check": True},
        )


def backup_dotfile(dfile: os.PathLike) -> None:
    """
    move current dotfiles to BACKUPS_DIR
    """
    do_job(
        f"Directory {BACKUP_TMP_DIR} created",
        Path.mkdir,
        {
            "self": BACKUP_TMP_DIR,
            "parents": True,
            "exist_ok": True,
        },
    )

    src = HOME_DIR / dfile
    dst = BACKUP_TMP_DIR / dfile
    write_stdout(f"Backing up {src}")
    if src.exists():
        if not src.is_symlink():
            # main backup logic happens here
            if not dst.parent.exists() and dst.parent != BACKUP_TMP_DIR:
                do_job(
                    f"Directory {dst.parent} created",
                    Path.mkdir,
                    {
                        "self": dst.parent,
                        "parents": True,
                        "exist_ok": True,
                    },
                )
            if src.is_file():
                do_job(
                    f"File {src} backed up to {BACKUP_TMP_DIR}",
                    shutil.move,
                    {
                        "src": src,
                        "dst": BACKUP_TMP_DIR / src.relative_to(HOME_DIR),
                    },
                )
            else:
                do_job(
                    f"Directory {dst} created at {BACKUP_TMP_DIR}",
                    Path.mkdir,
                    {
                        "self": dst,
                        "parents": True,
                        "exist_ok": True,
                    },
                )
                for subfile in src.iterdir():
                    backup_dotfile(subfile.relative_to(HOME_DIR))
                write_stdout(f"Backup of dotfiles created in {BACKUP_TMP_DIR}")
        else:
            do_job(
                f"Symlink {src} removed",
                os.unlink,
                {"path": src},
            )


def cli_install_dotfiles_and_scripts(
    do_pre_backup: bool = True,
    do_after_backup: bool = True,
    do_install_scripts: bool = True,
) -> None:
    """
    Install dotfiles with
    optionally create backups and install scripts.
    """
    do_job("Check directories existence", check_dirs, {})
    if do_pre_backup:
        for dfile in DOTFILES:
            backup_dotfile(dfile)
        archive_file = do_job(
            "Create backup archive",
            create_archive,
            {
                "archive_name": "backup_pre_install",
                "archive_store_folder": BACKUPS_DIR,
                "dir_to_archive": BACKUP_TMP_DIR,
            },
        )
        if archive_file:
            write_stdout(f"Backup archive created in {archive_file}")
        do_job(
            "Remove backup tmp dir",
            shutil.rmtree,
            {
                "path": BACKUP_TMP_DIR,
            },
        )

    for dfile in DOTFILES:
        if not install_dotfile(dfile):
            write_stderr(f"failed during installation of {dfile}")

    if do_install_scripts and INSTALLER_DIR:
        if not INSTALLER_DIR.exists():
            return
        install_scripts()


def cli_uninstall_dotfiles(do_restore_backup: bool = True) -> None:
    """
    Uninstall dotfiles and optionally restore backups (only normal backups).
    """
    raise NotImplementedError("cli_uninstall_dotfiles not implemented")


def cli_backup_dotfiles() -> None:
    """
    Create a backup of dotfiles.
    show menu of backups from BACKUPS_DIR
    choose backup to restore
    restore backup
    """
    raise NotImplementedError("cli_backup_dotfiles not implemented.")


def check_exists() -> None:
    """
    give state about non-existed dotfiles and already existed files
    """
    for dfile in DOTFILES:
        if not (DOTFILES_DIR / dfile).exists():
            write_stderr(f"Error: {dfile} not found in dotfiles directory.")
        if (HOME_DIR / dfile).exists():
            write_stderr(f"Error: {dfile} already exists in home directory.")


def get_actions() -> list[dict[str, str | Callable | dict[str, bool]]]:
    return [
        {
            "name": "install",
            "help": "Install dotfiles and scripts.",
            "func": cli_install_dotfiles_and_scripts,
            "args": {
                "do_pre_backup": True,
                "do_after_backup": True,
                "do_install_scripts": True,
            },
        },
        {
            "name": "onlydotfiles",
            "help": "Install dotfiles",
            "func": cli_install_dotfiles_and_scripts,
            "args": {
                "do_pre_backup": False,
                "do_after_backup": False,
                "do_install_scripts": False,
            },
        },
        {
            "name": "uninstall",
            "help": "NOT_IMPLEMENTED Uninstall dotfiles",
            "func": cli_uninstall_dotfiles,
            "args": {
                "do_restore_backup": True,
            },
        },
        {
            "name": "nobcuninstall",
            "help": "Uninstall dotfiles without restoring backups.",
            "func": cli_uninstall_dotfiles,
            "args": {
                "do_restore_backup": False,
            },
        },
        {
            "name": "backup",
            "help": "NOT_IMPLEMENTED Backup dotfiles and scripts.",
            "func": cli_backup_dotfiles,
            "args": {},
        },
        {
            "name": "check_exists",
            "help": "give state about non-existed dotfiles and already existed files",
            "func": check_exists,
            "args": {},
        },
    ]


def main() -> None:
    global DRY_RUN
    global VERBOSE
    global DOTFILES
    global INSTALLER_DIR
    parser = argparse.ArgumentParser(description="Install dotfiles.")
    parser.add_argument(
        "action",
        choices=[action["name"] for action in get_actions()],
        help="Action to perform.",
    )
    parser.add_argument(
        "--x11",
        action="store_true",
        help="Install X11 related dotfiles.",
    )
    parser.add_argument(
        "--no-scripts",
        action="store_true",
        help="Do not install scripts.",
    )
    parser.add_argument(
        "--wayland",
        action="store_true",
        help="Install Wayland related dotfiles.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Do not perform any action. Just print what would be done. have too much verbosity",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print more information.",
    )
    args = parser.parse_args()

    if not args.dry_run:
        DRY_RUN = False
    if args.verbose:
        VERBOSE = True

    if args.x11:
        DOTFILES = DOTFILES + OTHER_DOTFILES["x11"]
    if args.wayland:
        DOTFILES = DOTFILES + OTHER_DOTFILES["wayland"]
    if args.no_scripts:
        INSTALLER_DIR = None

    action = next(
        (action for action in get_actions() if action["name"] == args.action),
        None,
    )
    if action:
        action["func"](**action["args"])  # type: ignore
    else:
        write_stderr(f"Error: Action {args.action} not found.")

    sys.exit(0)


if __name__ == "__main__":
    main()
