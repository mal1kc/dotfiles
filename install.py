#!/usr/bin/env python
# """BSD 3-Clause License
#
# Copyright (c) 2024-2026, mal1kc
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."""
#
# Links the dotfiles of this repo into $HOME (could be done with gnu stow, but
# i don't understand perl). See `install.py --help` and readme.md.
#
# - files of DOTFILES + the remembered --wayland / --x11 groups are symlinked
#   one by one, directories are real directories
# - machines/<desktop|laptop>/ mirrors $HOME and wins over the shared file
# - the machine comes from .this_is_desktop / .this_is_laptop in this repo
# - replaced files go to .dotfiles_backups/, the last 3 archives are kept
# - log of the last change: dotfiles_installer.log
#
import argparse
import logging
import os
import shutil
import socket
import subprocess
import sys
import tarfile
import tempfile
from collections import Counter
from pathlib import Path

HOME_DIR: Path = Path.home()
DOTFILES_DIR: Path = Path(__file__).resolve().parent
LOGFILE: Path = DOTFILES_DIR / "dotfiles_installer.log"
PROFILE_FILE: Path = DOTFILES_DIR / ".install_profile"
BACKUPS_DIR: Path = DOTFILES_DIR / ".dotfiles_backups"
BACKUP_BASE_NAME = "dotfiles_bckp"
BACKUP_MAX_LMT = 3

MACHINES = ("desktop", "laptop")
PROFILES = ("wayland", "x11")
SKIP_NAMES = {"__pycache__", ".git"}

DOTFILES: list[str] = [
    # .config
    ".config/bat",
    ".config/btop",
    ".config/fish",
    ".config/gamemode.ini",
    ".config/kanata",
    ".config/kitty",
    ".config/mpv",
    ".config/nnn",
    ".config/nsxiv",
    ".config/selection_tool",
    ".config/sounds",
    ".config/systemd",
    ".config/tmux",
    ".config/wallust",
    ".config/yazi",
    ".config/zsh",
    # .local
    ".local/bin",
    ".local/share/applications",
    ".bashrc",
    ".gitconfig_aliases",
    # import gitconfig aliases
    # [include]
    #   path = ~/.gitconfig_aliases
    ".inputrc",
    ".zshrc",
]

PROFILE_DOTFILES: dict[str, list[str]] = {
    "x11": [
        ".Xresources",
        ".config/i3",
        ".xinitrc",
        ".xprofile",
        # ".config/picom.conf",
        # ".config/rofi",
    ],
    "wayland": [
        ".config/foot",
        ".config/fuzzel",
        ".config/hypr",
        ".config/niri",
        ".config/river",
        ".config/waybar",
        # ".config/wofi",
    ],
}

# only on that machine, together with that profile
MACHINE_DOTFILES: dict[str, dict[str, list[str]]] = {
    "desktop": {"wayland": [".config/noctalia", ".config/swaync"]},
    "laptop": {"wayland": [".config/ashell", ".config/fnott"]},
}

# where links into this repo can be, for prune and status
LINK_ROOTS = (".config", ".local/bin", ".local/share/applications")

LOGGER = logging.getLogger("dotfiles")


class InstallError(Exception):
    pass


# -- machine and profile


def marker(machine: str) -> Path:
    return DOTFILES_DIR / f".this_is_{machine}"


def marked_machine() -> str | None:
    found = [m for m in MACHINES if marker(m).exists()]
    if len(found) > 1:
        raise InstallError(
            "both .this_is_desktop and .this_is_laptop exist, "
            "keep one with: install.py machine <desktop|laptop>"
        )
    return found[0] if found else None


def hostname_machine() -> str:
    # same rule as .local/bin/machine_type
    return "laptop" if "laptop" in socket.gethostname().lower() else "desktop"


def set_machine(machine: str, dry_run: bool) -> None:
    LOGGER.info("machine: %s", machine)
    if dry_run:
        return
    for other in MACHINES:
        if other != machine:
            marker(other).unlink(missing_ok=True)
    marker(machine).touch()


def get_machine(ask: bool, dry_run: bool) -> str:
    machine = marked_machine()
    if machine:
        return machine
    guess = hostname_machine()
    if not ask or not sys.stdin.isatty():
        return guess
    answer = input(f"which machine is this, desktop or laptop? [{guess}] ").strip()
    machine = answer or guess
    if machine not in MACHINES:
        raise InstallError(f"unknown machine '{machine}'")
    set_machine(machine, dry_run)
    return machine


def get_profiles(args: argparse.Namespace) -> list[str]:
    given = [p for p in PROFILES if getattr(args, p)]
    if given or not PROFILE_FILE.exists():
        return given
    saved = PROFILE_FILE.read_text().split()
    return [p for p in PROFILES if p in saved]


# -- what to link


def selected_entries(machine: str, profiles: list[str]) -> list[str]:
    entries = list(DOTFILES)
    for profile in profiles:
        entries += PROFILE_DOTFILES[profile]
        entries += MACHINE_DOTFILES[machine].get(profile, [])
    return entries


def files_under(root: Path, entry: str) -> list[Path]:
    """Paths of the files of an entry, relative to root."""
    path = root / entry
    if path.is_symlink() or path.is_file():
        return [Path(entry)]
    files: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(path):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_NAMES)
        # a symlink to a directory is linked like a file
        linked = [d for d in dirnames if Path(dirpath, d).is_symlink()]
        dirnames[:] = [d for d in dirnames if d not in linked]
        files += [
            Path(dirpath, name).relative_to(root)
            for name in sorted(filenames) + linked
            if name not in SKIP_NAMES
        ]
    return files


def wanted_links(machine: str, profiles: list[str]) -> dict[Path, Path]:
    """{path relative to $HOME: file in this repo}"""
    links: dict[Path, Path] = {}
    overlay = DOTFILES_DIR / "machines" / machine
    for entry in selected_entries(machine, profiles):
        for root in (DOTFILES_DIR, overlay):  # the overlay wins
            for rel in files_under(root, entry):
                links[rel] = root / rel
    return links


def link_target(link: Path) -> Path:
    """Absolute target of a symlink, without resolving further links."""
    return Path(os.path.normpath(link.parent / os.readlink(link)))


def in_repo(path: Path) -> bool:
    return path.is_relative_to(DOTFILES_DIR)


# -- backup


class Backup:
    """Keeps replaced files; makes an archive only if there were any."""

    def __init__(self) -> None:
        self.staging: Path | None = None

    def add(self, path: Path) -> Path:
        if self.staging is None:
            BACKUPS_DIR.mkdir(exist_ok=True)
            # kept if we crash, so nothing is ever lost
            self.staging = Path(tempfile.mkdtemp(prefix="staging_", dir=BACKUPS_DIR))
        kept = self.staging / path.relative_to(HOME_DIR)
        kept.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(path, kept)
        return kept

    def archive(self) -> Path | None:
        if self.staging is None:
            return None
        tmp = BACKUPS_DIR / f"{BACKUP_BASE_NAME}.new.tar.gz"
        with tarfile.open(tmp, "w:gz") as tar:
            for child in sorted(self.staging.iterdir()):
                tar.add(child, arcname=child.name)
        with tarfile.open(tmp) as tar:  # readable before the originals go
            tar.getmembers()

        def numbered(n: int) -> Path:
            return BACKUPS_DIR / f"{BACKUP_BASE_NAME}.{n}.tar.gz"

        for n in range(BACKUP_MAX_LMT - 1, 0, -1):  # 2->3 before 1->2
            if numbered(n).exists():
                os.replace(numbered(n), numbered(n + 1))
        os.replace(tmp, numbered(1))
        shutil.rmtree(self.staging)
        self.staging = None
        return numbered(1)


# -- actions


def prepare_parents(dst: Path, dry_run: bool) -> bool:
    """
    Make the parents of dst real directories. A parent that links into this
    repo is replaced, otherwise we would create links inside the repo.
    Returns True if there was one (then nothing of the user's is below it).
    """
    replaced = False
    for parent in reversed(dst.relative_to(HOME_DIR).parents):
        path = HOME_DIR / parent
        if path.is_symlink() and in_repo(link_target(path)):
            LOGGER.info("unlink directory link %s", path)
            if dry_run:
                return True
            path.unlink()
            replaced = True
        if path.exists() and not path.is_dir():
            raise InstallError(f"{path} is not a directory")
        if not dry_run:
            path.mkdir(exist_ok=True)
    return replaced


def is_linked(dst: Path, src: Path) -> bool:
    if not (dst.is_symlink() and link_target(dst) == src):
        return False
    return not any(
        (HOME_DIR / p).is_symlink() and in_repo(link_target(HOME_DIR / p))
        for p in dst.relative_to(HOME_DIR).parents
    )


def link_file(dst: Path, src: Path, backup: Backup, dry_run: bool) -> str:
    """Returns what was done: linked, relinked, unchanged or 'backed up'."""
    if is_linked(dst, src):
        return "unchanged"
    replaced = prepare_parents(dst, dry_run)

    result, kept = "linked", None
    if replaced:
        pass  # dst can't exist in a new directory
    elif dst.is_symlink() and in_repo(link_target(dst)):
        result = "relinked"
        if not dry_run:
            dst.unlink()
    elif dst.is_dir() and not dst.is_symlink():
        raise InstallError(f"{dst} is a directory, {src} is a file")
    elif os.path.lexists(dst):
        result = "backed up"
        if not dry_run:
            kept = backup.add(dst)

    LOGGER.info("%s %s -> %s", result, dst, src)
    if not dry_run:
        try:
            dst.symlink_to(src)
        except OSError:
            if kept is not None:
                shutil.move(kept, dst)
            raise
    return result


def do_install(args: argparse.Namespace) -> int:
    machine = get_machine(ask=True, dry_run=args.dry_run)
    profiles = get_profiles(args)
    if profiles and not args.dry_run:
        PROFILE_FILE.write_text(" ".join(profiles) + "\n")
    LOGGER.info("machine: %s, profiles: %s", machine, " ".join(profiles) or "none")

    done: Counter[str] = Counter()
    backup = Backup()
    try:
        for rel, src in wanted_links(machine, profiles).items():
            try:
                done[link_file(HOME_DIR / rel, src, backup, args.dry_run)] += 1
            except (OSError, InstallError) as err:
                LOGGER.error("failed %s: %s", rel, err)
                done["failed"] += 1
    finally:
        archive = backup.archive()

    print(f"{machine}, profiles: {' '.join(profiles) or 'none'}")
    summary = ("linked", "relinked", "unchanged", "backed up", "failed")
    print(", ".join(f"{done[name]} {name}" for name in summary))
    if archive:
        print(f"replaced files are in {archive}")
    if args.prune:
        do_prune(args)
    if args.reload:
        reload_hyprland(args.dry_run)
    return 1 if done["failed"] else 0


def dead_links() -> list[Path]:
    """Dead symlinks that point into this repo."""
    candidates = [p for p in HOME_DIR.iterdir() if p.is_symlink()]
    for root in LINK_ROOTS:
        for dirpath, dirnames, filenames in os.walk(HOME_DIR / root):
            if in_repo(Path(dirpath)):
                dirnames.clear()
                continue
            candidates += [
                path
                for name in dirnames + filenames
                if (path := Path(dirpath, name)).is_symlink()
            ]
    return sorted(
        p for p in set(candidates) if in_repo(link_target(p)) and not p.exists()
    )


def do_prune(args: argparse.Namespace) -> int:
    links = dead_links()
    for link in links:
        LOGGER.info("remove dead link %s -> %s", link, link_target(link))
        if not args.dry_run:
            link.unlink()
    print(f"{len(links)} dead links {'found' if args.dry_run else 'removed'}")
    return 0


def git(*cmd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "-C", str(DOTFILES_DIR), *cmd], capture_output=True, text=True
    )


def git_out(*cmd: str) -> str:
    result = git(*cmd)
    if result.returncode != 0:
        raise InstallError(f"git {' '.join(cmd)}: {result.stderr.strip()}")
    return result.stdout.strip()


def reload_hyprland(dry_run: bool) -> None:
    if not os.environ.get("HYPRLAND_INSTANCE_SIGNATURE"):
        return
    if not shutil.which("hyprctl"):
        return
    LOGGER.info("reload hyprland")
    if not dry_run:
        subprocess.run(["hyprctl", "reload"], check=False)


def do_update(args: argparse.Namespace) -> int:
    marked_machine()  # both markers: stop before pulling
    changes = git_out("status", "--porcelain", "--untracked-files=no")
    if changes:
        raise InstallError(f"commit or stash these first:\n{changes}")
    if args.dry_run:
        git_out("fetch")
        print(git_out("log", "--oneline", "HEAD..@{upstream}") or "up to date")
        return 0
    old = git_out("rev-parse", "--short", "HEAD")
    git_out("pull", "--ff-only")
    new = git_out("rev-parse", "--short", "HEAD")
    print(f"{old} -> {new}" if old != new else f"{old} up to date")
    if old != new:
        print(git_out("log", "--oneline", f"{old}..{new}"))

    # run the install.py that was just pulled
    cmd = [sys.executable, str(DOTFILES_DIR / "install.py"), "install"]
    cmd += ["--prune", "--reload"]
    cmd += [f"--{p}" for p in PROFILES if getattr(args, p)]
    cmd += ["--verbose"] if args.verbose else []
    sys.stdout.flush()
    return subprocess.run(cmd, check=False).returncode


def do_status(args: argparse.Namespace) -> int:
    marked = marked_machine()
    machine = marked or hostname_machine()
    profiles = get_profiles(args)
    print(f"repo:     {DOTFILES_DIR}")
    print(f"machine:  {machine} ({'marker' if marked else 'guessed from hostname'})")
    print(f"profiles: {' '.join(profiles) or 'none'}")

    branch = git("branch", "--show-current").stdout.strip() or "detached"
    counts = git("rev-list", "--left-right", "--count", "HEAD...@{upstream}")
    if counts.returncode == 0:
        ahead, behind = counts.stdout.split()
        print(f"branch:   {branch}, {ahead} ahead, {behind} behind (last fetch)")
    else:
        print(f"branch:   {branch}, no upstream")

    problems = 0
    for rel, src in wanted_links(machine, profiles).items():
        dst = HOME_DIR / rel
        if is_linked(dst, src):
            continue
        problems += 1
        if not os.path.lexists(dst):
            print(f"missing  ~/{rel}")
        elif dst.is_symlink():
            print(f"wrong    ~/{rel} -> {os.readlink(dst)}")
        else:
            print(f"not a link ~/{rel}")
    for link in dead_links():
        problems += 1
        print(f"dead     ~/{link.relative_to(HOME_DIR)}")
    print(f"{problems} problems" if problems else "all links are fine")
    return 1 if problems else 0


def do_check_exists(args: argparse.Namespace) -> int:
    machine = marked_machine() or hostname_machine()
    missing = 0
    for entry in selected_entries(machine, get_profiles(args)):
        roots = (DOTFILES_DIR, DOTFILES_DIR / "machines" / machine)
        exists = any(os.path.lexists(root / entry) for root in roots)
        missing += not exists
        print(f"{'exists ' if exists else 'missing'} {entry}")
    return 1 if missing else 0


def do_machine(args: argparse.Namespace) -> int:
    if args.value:
        set_machine(args.value, args.dry_run)
        print(args.value)
        return 0
    marked = marked_machine()
    print(marked or f"{hostname_machine()} (guessed from hostname)")
    return 0


def do_packages(args: argparse.Namespace) -> int:
    script = DOTFILES_DIR / "dotfiles_installers" / "archlinux_and_aur_install.sh"
    cmd = [str(script), "list" if args.dry_run else "install"]
    return subprocess.run(cmd, check=False).returncode


ACTIONS = {
    "install": (do_install, "link the dotfiles"),
    "update": (do_update, "git pull, then install, prune and reload hyprland"),
    "status": (do_status, "machine, branch and wrong/missing/dead links"),
    "prune": (do_prune, "remove dead links that point into this repo"),
    "machine": (do_machine, "show or set the machine: machine [desktop|laptop]"),
    "packages": (do_packages, "install the package list (arch, aur)"),
    "check_exists": (do_check_exists, "do the configured dotfiles exist in this repo"),
}


def setup_logging(args: argparse.Namespace) -> None:
    LOGGER.setLevel(logging.INFO)
    if args.verbose or args.dry_run:
        LOGGER.addHandler(logging.StreamHandler(sys.stdout))
    else:
        errors = logging.StreamHandler(sys.stderr)
        errors.setLevel(logging.ERROR)
        LOGGER.addHandler(errors)
    if args.action in ("install", "prune") and not args.dry_run:
        handler = logging.FileHandler(LOGFILE, "w", "utf-8")
        handler.setFormatter(
            logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
        )
        LOGGER.addHandler(handler)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Link the dotfiles of this repo into $HOME.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="actions:\n"
        + "\n".join(f"  {name:<13} {text}" for name, (_, text) in ACTIONS.items()),
    )
    _ = parser.add_argument("action", choices=list(ACTIONS), metavar="action")
    _ = parser.add_argument("value", nargs="?", help="only for the machine action")
    for profile in PROFILES:
        _ = parser.add_argument(
            f"--{profile}",
            action="store_true",
            help=f"include {profile} dotfiles (remembered for the next runs)",
        )
    _ = parser.add_argument(
        "--dry-run", action="store_true", help="only print what would be done"
    )
    _ = parser.add_argument("--verbose", action="store_true", help="print every change")
    _ = parser.add_argument("--prune", action="store_true", help="install: also prune")
    _ = parser.add_argument(
        "--reload", action="store_true", help="install: also reload hyprland"
    )
    args = parser.parse_intermixed_args()

    if args.value and args.action != "machine":
        parser.error(f"{args.action} takes no value")
    if args.value and args.value not in MACHINES:
        parser.error(f"machine must be one of: {', '.join(MACHINES)}")

    setup_logging(args)
    try:
        return ACTIONS[args.action][0](args)
    except InstallError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
