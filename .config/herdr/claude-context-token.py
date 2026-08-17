#!/usr/bin/env python3
import json
import os
import subprocess
import sys

TAIL_BYTES = 1_048_576


def latest_usage(path):
    with open(path, "rb") as fh:
        fh.seek(0, os.SEEK_END)
        size = fh.tell()
        fh.seek(max(0, size - TAIL_BYTES))
        chunk = fh.read()
    lines = chunk.split(b"\n")
    if size > TAIL_BYTES:
        lines = lines[1:]
    for line in reversed(lines):
        if not line.strip():
            continue
        try:
            entry = json.loads(line)
        except ValueError:
            continue
        if entry.get("isSidechain"):
            continue
        message = entry.get("message")
        if not isinstance(message, dict):
            continue
        usage = message.get("usage")
        if isinstance(usage, dict):
            return usage
    return None


def main():
    pane = os.environ.get("HERDR_PANE_ID")
    if not pane:
        return
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        payload = {}
    path = payload.get("transcript_path")
    if not path or not os.path.exists(path):
        return
    usage = latest_usage(path)
    if not usage:
        return
    total = sum(
        usage.get(k, 0) or 0
        for k in (
            "input_tokens",
            "cache_creation_input_tokens",
            "cache_read_input_tokens",
            "output_tokens",
        )
    )
    if total > 400_000:
        active = "ctx_crit"
    elif total > 250_000:
        active = "ctx_warn"
    else:
        active = "ctx"
    args = ["herdr", "pane", "report-metadata", pane, "--source", "claude-context"]
    for key in ("ctx", "ctx_warn", "ctx_crit"):
        if key == active:
            args += ["--token", f"{key}={total // 1000}k"]
        else:
            args += ["--clear-token", key]
    subprocess.run(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


main()
