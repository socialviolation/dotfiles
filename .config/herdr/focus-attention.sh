#!/usr/bin/env bash

set -uo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

target=$(herdr agent list 2>/dev/null | jq -r '
  .result.agents
  | map(select(.agent_status=="done" or .agent_status=="blocked" or .agent_status=="idle"))
  | if length==0 then empty
    else max_by([
        (if .agent_status=="done" then 2 elif .agent_status=="blocked" then 1 else 0 end),
        .state_change_seq
      ]).pane_id
    end')

[ -n "$target" ] || exit 0

herdr agent focus "$target" > /dev/null
