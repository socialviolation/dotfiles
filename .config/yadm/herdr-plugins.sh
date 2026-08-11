#!/bin/bash

# Declarative herdr plugin set. herdr has no manifest/sync verb of its own, so
# this is the source of truth: plugin_id -> "owner/repo[ ref]".
# Sourced by yadm bootstrap (fresh machine) and hooks/post_pull (config updates).

set -uo pipefail

# yadm hooks run non-interactive, where ~/.local/bin (herdr's home) and cargo — needed by
# plugins that build from source — may be absent from PATH.
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$HOME/.cargo/bin:$PATH"

# yadm exports GIT_DIR/GIT_WORK_TREE to its hooks. herdr plugin install shells out to git,
# which would otherwise init/remote-add against the yadm repo instead of the plugin checkout.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

declare -A HERDR_PLUGINS=(
    ["herdr.collie"]="AltanS/collie"
    ["herdr-file-viewer"]="smarzban/herdr-file-viewer"
    ["herdr-navigator"]="thanhdat77/herdr-navigator v0.3.3"
)

if ! command -v herdr &> /dev/null; then
    echo "==> herdr not installed, skipping plugins (curl -fsSL https://herdr.dev/install.sh | sh)"
    return 0 2>/dev/null || exit 0
fi

installed=$(herdr plugin list --json 2>/dev/null |
    python3 -c 'import json,sys
try: print("\n".join(p["plugin_id"] for p in json.load(sys.stdin)["result"]["plugins"]))
except Exception: pass' 2>/dev/null)

changed=0
for id in "${!HERDR_PLUGINS[@]}"; do
    if grep -qxF "$id" <<< "$installed"; then
        echo "==> $id already installed"
        continue
    fi
    read -r repo ref <<< "${HERDR_PLUGINS[$id]}"
    echo "==> Installing $id from $repo${ref:+ @$ref}"
    if herdr plugin install "$repo" ${ref:+--ref "$ref"} --yes; then
        changed=1
    else
        echo "==> WARNING: failed to install $id" >&2
    fi
done

if [ "$changed" = 1 ] && [ -S "$HOME/.config/herdr/herdr.sock" ]; then
    echo "==> Reloading herdr config"
    herdr server reload-config > /dev/null
fi
