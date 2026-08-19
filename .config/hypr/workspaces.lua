-- Workspace rules for the dual-monitor setup.
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })

for _, workspace in ipairs({ "2", "3", "4", "5" }) do
  hl.workspace_rule({ workspace = workspace, monitor = "HDMI-A-2", default = workspace == "2" })
end
