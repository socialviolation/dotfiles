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

## herdr

Two unrelated faults, both mistaken for a broken hotkey.

**`prefix + l` did nothing.** `h`, `j` and `k` worked. A `[[keys.command]]`
entry claimed `prefix+l` for `devstack.open-panel`, which killed the default
`focus_pane_right`. `herdr config check` had been reporting it all along:

```
prefix+l: kept keys.focus_pane_right, disabled keys.command[5].key
```

fcitx5 and Claude Code were both blamed first and both were innocent. fcitx5
is disabled now anyway; re-enable with
`systemctl --user enable --now omarchy-fcitx5.service` if you want it back.

**The devstack panel opened nothing.** Two layers:

- mise had no global `go`, so the `go:` backend shim could not run and
  `devstack` errored with `No version is set for shim`. Fixed by
  `mise use -g go@latest` plus
  `mise use -g "go:github.com/socialviolation/devstack@latest"`.
- the herdr server and client run with a PATH that has no
  `~/.local/share/mise/shims`, because mise is activated per-shell rather than
  shimmed globally. `devstack` existed interactively and did not exist for
  herdr, so the panes died instantly. Fixed with a symlink into
  `~/.local/bin`, which is on both PATHs:

```
~/.local/bin/devstack -> ~/.local/share/mise/installs/
                         go-github-com-socialviolation-devstack/latest/bin/devstack
```

Not tracked in yadm — it points into a machine-specific mise path.

Current bindings, chosen to avoid double modifiers:

| Key | Action |
| --- | --- |
| `prefix+y` | devstack panel in a split |
| `prefix+shift+y` | devstack address picker |
| `prefix+h/j/k/l` | focus pane, all four working |
| `ctrl+alt+h/j/k/l` | focus pane, direct, no prefix |

### Gotchas

`herdr server reload-config` reloads the **server**. Keybindings live in the
**client**, so use `prefix + shift + r` after editing `config.toml`.

`prefix+ctrl+...` does not appear anywhere in `herdr --default-config`; its
only modified-prefix examples are `prefix+alt+g` and `prefix+alt+1..9`.
`herdr config check` returns `ok` for a combo it cannot deliver — it only
looks for collisions.

`omarchy-menu-herdr-keybindings --print` lists defaults from the `[keys]`
section only. Every `[[keys.command]]` entry is invisible there, which is why
the `prefix+l` collision never showed up in the menu.

## Open

**`~/.config/omarchy/shell.json` is tracked, and this repo is public.**
The Spotify plugin writes runtime state into it — search history and a
session blob naming recently played albums. The committed copy predates the
plugin and is clean. Either untrack the file or strip that state before every
commit.

**`~/.claude/settings.json` is deliberately held out of the repo.** Its local
changes carry work infrastructure detail that does not belong in a public
repo. The committed copy is clean. Leave it uncommitted.

**`~/.config/nvim/lazy-lock.json`** is drifting on its own. Unrelated.
