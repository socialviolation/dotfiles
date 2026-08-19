# Omarchy quattro upgrade — what changed and why

Log of the config repair after upgrading to quattro on 2026-08-19.
Branch: `omarchy-quattro-config`. Not merged to master yet.

## What quattro changed underneath

Two breaking moves caused almost everything below.

**Hyprland config went from `.conf` to `.lua`.** The upgrade wrote stock
`hyprland.lua`, `bindings.lua`, `looknfeel.lua`, `input.lua`, `monitors.lua`
and `autostart.lua`. The old `.conf` files stayed on disk but nothing sourced
them, so every personal setting silently stopped applying.

**Omarchy state moved** from `~/.config/omarchy/current` to
`~/.local/state/omarchy/current`. Anything pointing at the old path broke.

## Hyprland port

Old `.conf` files are archived in `~/.config/hypr/pre-quattro-backup/`.
Nothing was deleted.

| File | What was restored |
| --- | --- |
| `monitors.lua` | `GDK_SCALE=1`, both monitors pinned 1920x1080@60 |
| `looknfeel.lua` | gaps 2, rounding 4, cursor warp on workspace change |
| `input.lua` | natural scroll, sensitivity 0.35, repeat 50/350 |
| `bindings.lua` | monitor focus/move keys, copy-latest-screenshot |
| `workspaces.lua` | new file, 1 to HDMI-A-1, 2-5 to HDMI-A-2 |

`hyprland.lua` gained one line: `require("hypr.workspaces")`.

Stock `monitors.lua` sets `GDK_SCALE=2`. On 1080p that renders GTK apps at
roughly 300%. This was the cause of the giant Spotify window.

Five things were dropped because quattro now ships them:

- NVIDIA env vars — `default/hypr/nvidia.lua` autodetects, GSP branch, same
  three values
- `MOZ_ENABLE_WAYLAND` — set in `default/hypr/envs.lua`
- the dbus `exec-once` line — in `default/hypr/autostart.lua`
- DaVinci Resolve window rules — shipped as `apps/davinci-resolve.lua`
- the `zen-browser` override — xdg default is already `zen.desktop`

### Keys quattro had taken

Each needs `hl.unbind` before rebinding, or the default wins.

| Key | Quattro default | Now |
| --- | --- | --- |
| `SUPER+comma` | Dismiss last notification | Focus previous monitor |
| `SUPER+SHIFT+comma` | Dismiss all notifications | Move window to prev monitor |
| `SUPER+SHIFT+S` | Google Maps webapp | Copy latest screenshot |
| `SUPER+SHIFT+M` | Launch Spotify client | Quickshell Spotify plugin |

`SUPER+S` and `SUPER+ALT+S` stay unbound, as before.

## Per-monitor workspace numbers in the bar

Stock `omarchy.workspaces` draws every workspace on every monitor. Cloned it
to `~/.config/omarchy/plugins/nick.workspaces/` and filtered the model by
`QsWindow.window.screen.name`, so a number renders only on the monitor that
owns its workspace and follows it when a hotkey moves it.

The workspace rules are `persistent = true` for this. Hyprland only reports a
monitor for a workspace that exists, so without it an empty workspace would
show on neither bar.

**Gotcha:** `omarchy-shell shell rescanPlugins` reloads plugin files but does
not rebuild the bar surfaces, so widget edits look like they did nothing.
`omarchy restart shell` is what applies them.

## Path fixes

- `~/.config/alacritty/alacritty.toml` — `general.import` repointed at
  `~/.local/state/omarchy/`
- `~/.config/nvim/lua/plugins/theme.lua` — symlink repointed, now relative
- Same file had an invalid trailing inline table at line 28 that broke TOML
  parsing entirely. Removed. The binding it duplicated already existed inside
  the `bindings` array.

## Applications

**Slack was never broken.** `~/.local/bin/slack` is the Slack *CLI*, which
shadows `/usr/bin/slack` (the desktop app) on PATH. Predates quattro.
The `.desktop` entry uses the absolute path and launches fine.

**Spotify** — official client uninstalled in favour of the
`quickshell.spotify` plugin. Two things had to change first:

- plugin setting `shortcutPlayer` to `Full player`; on the default
  `Omarchy Music app` it runs `omarchy launch spotify`, and
  `omarchy-launch-spotify` falls through to its *installer* when
  `/usr/bin/spotify` is missing
- `SUPER+SHIFT+M` rebound to
  `omarchy-shell quickshell.spotify.player togglePlayer`

**Ghostty** was already installed and already the default terminal.
`clipboard-write = allow`, so nvim OSC52 yank works. `clipboard-read = ask`,
which only matters over ssh.

## Open

**herdr `prefix + hjkl` pane switching is still broken.** Unresolved.

fcitx5 was the first suspect — `omarchy-fcitx5.service` went active with the
quattro session and its default trigger key is `Ctrl+Space`, the same as the
herdr prefix. The service is now disabled and the keys still do not work, so
fcitx5 was not the cause.

Ruled out so far:

- `herdr config check` returns `config: ok`
- `~/.config/herdr/config.toml` sets `prefix = "ctrl+space"` and does not
  rebind pane navigation
- the focused tab genuinely has 2 panes, so there is something to switch to
- ghostty has no keybind on `ctrl+space`, so it is not swallowing it

Prime suspect is the terminal swap to ghostty and how `Ctrl+Space` is encoded
on the wire. Next test: in a herdr pane run `cat -v` and press `Ctrl+Space`.
`^@` means the legacy NUL byte, which is what herdr expects. A
`^[[32;5u`-shaped sequence means the Kitty keyboard protocol instead.
Also worth knowing whether any other prefix binding works, such as
`prefix + b` for the sidebar — that separates "prefix never arrives" from
"only pane navigation is broken".

Note `omarchy-menu-herdr-keybindings --print` appears to list defaults rather
than the merged config: it shows `PREFIX + V` for split vertical while the
config file sets `prefix+"`. Do not treat that output as authoritative.

**`~/.config/omarchy/shell.json` is tracked, and this repo is public.**
The Spotify plugin writes runtime state into it — search history and a
session blob naming recently played albums. The committed copy predates the
plugin and is clean. Either untrack the file or strip that state before every
commit.

**`~/.claude/settings.json` is deliberately held out of the repo.** Its local
changes carry work infrastructure detail that does not belong in a public
repo. The committed copy is clean. Leave it uncommitted.

**`~/.config/nvim/lazy-lock.json`** is drifting on its own. Unrelated.
