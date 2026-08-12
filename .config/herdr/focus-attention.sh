#!/usr/bin/env bash

set -uo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

log="${XDG_CACHE_HOME:-$HOME/.cache}/herdr-focus-attention.log"
note() { printf '%s %s\n' "$(date -Is)" "$*" >> "$log"; }

note "fired: pwd=$PWD herdr=$(command -v herdr || echo MISSING) jq=$(command -v jq || echo MISSING)"

if ! command -v herdr > /dev/null || ! command -v jq > /dev/null; then
    note "abort: missing dependency"
    exit 1
fi

agents=$(herdr agent list 2>&1)
target=$(printf '%s' "$agents" | jq -r '
  .result.agents
  | map(select(.agent_status=="done" or .agent_status=="blocked"))
  | if length==0 then empty
    else max_by([(if .agent_status=="done" then 1 else 0 end), .state_change_seq]).pane_id
    end' 2>&1)

if [ -z "$target" ]; then
    note "no target; statuses=$(printf '%s' "$agents" | jq -rc '[.result.agents[].agent_status]' 2>&1)"
    herdr notification show "Nothing waiting" --sound none --position top-right > /dev/null
    exit 0
fi

note "focusing $target"
herdr agent focus "$target" > /dev/null 2>> "$log"
