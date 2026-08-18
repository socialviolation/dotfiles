#!/usr/bin/env python3
import json
import os
import re
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from comment_rules import reason_after, scan

WINDOW_SECONDS = 120
WRITEY = re.compile(r">|<<|\b(sed|tee|patch|cp|mv|install|dd|truncate)\b")


def git(root, *args):
    out = subprocess.run(("git",) + args, cwd=root, capture_output=True, text=True)
    return out.stdout if out.returncode == 0 else None


def repo_root(cwd):
    return (git(cwd, "rev-parse", "--show-toplevel") or "").strip() or None


def recently_written(root):
    status = git(root, "status", "--porcelain")
    if not status:
        return
    now = time.time()
    for line in status.splitlines():
        path = line[3:]
        if " -> " in path:
            path = path.split(" -> ")[-1]
        path = path.strip().strip('"')
        full = os.path.join(root, path)
        if not os.path.isfile(full):
            continue
        try:
            if now - os.path.getmtime(full) > WINDOW_SECONDS:
                continue
            with open(full, encoding="utf-8", errors="replace") as fh:
                after = fh.read()
        except OSError:
            continue
        before = git(root, "show", "HEAD:" + path) or ""
        yield path, before, after


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
    if payload.get("tool_name") != "Bash":
        return 0
    command = (payload.get("tool_input") or {}).get("command", "")
    if not WRITEY.search(command):
        return 0
    root = repo_root(payload.get("cwd") or os.getcwd())
    if not root:
        return 0
    for path, before, after in recently_written(root):
        findings = scan(path, before, after)
        if findings:
            sys.stderr.write(reason_after(path, findings))
            return 2
    return 0


sys.exit(main())
