-- Workspace rules for the dual-monitor setup.
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/

-- persistent keeps each workspace alive on its monitor even when empty, so the
-- bar widget can place every number by asking Hyprland which monitor owns it.
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true, persistent = true })

for _, workspace in ipairs({ "2", "3", "4", "5" }) do
  hl.workspace_rule({
    workspace = workspace,
    monitor = "HDMI-A-2",
    default = workspace == "2",
    persistent = true,
  })
end
