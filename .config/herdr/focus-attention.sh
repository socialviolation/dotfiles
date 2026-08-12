#!/usr/bin/env bash

set -uo pipefail

export PATH="$HOME/.local/bin:$PATH"

target=$(herdr agent list 2>/dev/null | jq -r '
  .result.agents
  | map(select(.agent_status=="done" or .agent_status=="blocked"))
  | if length==0 then empty
    else max_by([(if .agent_status=="done" then 1 else 0 end), .state_change_seq]).pane_id
    end')

if [ -z "$target" ]; then
    herdr notification show "Nothing waiting" --sound none --position top-right
    exit 0
fi

herdr agent focus "$target" > /dev/null
