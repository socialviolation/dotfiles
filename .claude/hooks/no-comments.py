#!/usr/bin/env python3
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from comment_rules import reason, scan


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return
    tool = payload.get("tool_name")
    if tool not in ("Edit", "Write"):
        return
    inp = payload.get("tool_input") or {}
    path = inp.get("file_path") or ""
    if tool == "Write":
        try:
            with open(path, encoding="utf-8", errors="replace") as fh:
                before = fh.read()
        except OSError:
            before = ""
        after = inp.get("content", "")
    else:
        before = inp.get("old_string", "")
        after = inp.get("new_string", "")
    findings = scan(path, before, after)
    if not findings:
        return
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason(path, findings),
    }}, sys.stdout)


main()
