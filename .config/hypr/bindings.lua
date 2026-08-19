-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.
--
-- See current bindings and descriptions:
--   omarchy menu keybindings --print

hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Copy latest screenshot", "omarchy-cmd-copy-latest-screenshot")

hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", "omarchy-shell quickshell.spotify.player togglePlayer")

o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

hl.unbind("SUPER + comma")
hl.unbind("SUPER + SHIFT + comma")

o.bind("SUPER + period", "Focus next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + comma", "Focus previous monitor", hl.dsp.focus({ monitor = "-1" }))
o.bind("SUPER + SHIFT + period", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))
o.bind("SUPER + SHIFT + comma", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))
o.bind("SUPER + CTRL + SHIFT + period", "Move workspace to next monitor", hl.dsp.workspace.move({ monitor = "+1" }))
o.bind("SUPER + CTRL + SHIFT + comma", "Move workspace to previous monitor", hl.dsp.workspace.move({ monitor = "-1" }))
