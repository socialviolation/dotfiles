#!/usr/bin/env python3
import json
import os
import re
import sys

CRITERIA = "~/.claude/skills/clean-comments/CRITERIA.md"

SKIP_EXT = {
    "md", "markdown", "mdx", "rst", "txt", "adoc", "org",
    "json", "csv", "tsv", "xml", "svg", "log", "patch", "diff", "sum", "lock",
    "yaml", "yml", "toml", "ini", "cfg", "conf", "properties", "env", "editorconfig",
    "png", "jpg", "jpeg", "gif", "webp", "ico", "pdf", "zip", "gz",
}

HASH = ("#",)
SLASH = ("//", "/*")
DASH = ("--",)
SEMI = (";",)

LANG = {
    "py": HASH, "pyi": HASH, "sh": HASH, "bash": HASH, "zsh": HASH, "fish": HASH,
    "rb": HASH, "pl": HASH, "pm": HASH, "r": HASH, "jl": HASH, "nix": HASH,
    "ex": HASH, "exs": HASH, "cr": HASH, "tcl": HASH, "awk": HASH, "ps1": HASH,
    "makefile": HASH, "dockerfile": HASH, "gradle": SLASH,
    "js": SLASH, "jsx": SLASH, "ts": SLASH, "tsx": SLASH, "mjs": SLASH, "cjs": SLASH,
    "mts": SLASH, "cts": SLASH, "go": SLASH, "rs": SLASH, "c": SLASH, "h": SLASH,
    "cpp": SLASH, "hpp": SLASH, "cc": SLASH, "hh": SLASH, "java": SLASH, "cs": SLASH,
    "kt": SLASH, "kts": SLASH, "swift": SLASH, "scala": SLASH, "php": SLASH,
    "dart": SLASH, "proto": SLASH, "groovy": SLASH, "zig": SLASH, "sol": SLASH,
    "glsl": SLASH, "css": ("/*",), "scss": SLASH, "less": SLASH, "sass": SLASH,
    "sql": DASH, "lua": DASH, "hs": DASH, "elm": DASH, "adb": DASH, "vhdl": DASH,
    "el": SEMI, "clj": SEMI, "cljs": SEMI, "cljc": SEMI, "lisp": SEMI, "scm": SEMI,
    "asm": SEMI, "s": SEMI, "ahk": SEMI,
    "vim": ('"',), "vimrc": ('"',),
    "tex": ("%",), "sty": ("%",), "erl": ("%",), "hrl": ("%",), "m": ("%",),
    "pro": ("%",), "prolog": ("%",),
    "f90": ("!",), "f95": ("!",), "f": ("!",),
    "vb": ("'",), "vbs": ("'",), "bas": ("'",),
    "html": ("<!--",), "htm": ("<!--",), "vue": ("<!--",), "svelte": ("<!--",),
    "ml": ("(*",), "mli": ("(*",), "pas": ("(*",),
}

UNIVERSAL = ("#", "//", "/*", "--", ";", "<!--")

BLOCK_CLOSE = {"/*": "*/", "<!--": "-->", "(*": "*)", "{-": "-}"}

DOC_LIMIT = 4

DOC_DECL = re.compile(
    r"^(func\s+(\([^)]*\)\s*)?[A-Z]|type\s+[A-Z]|var\s+[A-Z]|const\s+[A-Z])"
)

KEEPER = re.compile(
    r"https?://|noqa|pragma|eslint|biome-ignore|prettier-ignore|stylelint|deno-lint"
    r"|@ts-|ts-ignore|ts-expect-error|ts-nocheck|pylint|mypy|ruff|flake8|nosec|gosec"
    r"|nolint|go:build|go:generate|go:embed|\+build|type:\s*ignore|coding[:=]|-\*-"
    r"|spdx|copyright|licen[cs]e|do not edit|code generated|@flow|shellcheck",
    re.IGNORECASE,
)


def markers(path):
    name = os.path.basename(path).lower()
    ext = name.rsplit(".", 1)[-1] if "." in name else name
    if ext in SKIP_EXT:
        return ()
    return LANG.get(ext, UNIVERSAL)


def marker_of(text, marks):
    if not text or text.startswith("#!") or KEEPER.search(text):
        return None
    for mark in sorted(marks, key=len, reverse=True):
        if not text.startswith(mark):
            continue
        rest = text[len(mark):]
        if mark == "--" and rest and not rest[0].isspace():
            continue
        if mark in BLOCK_CLOSE:
            return mark
        if not re.search(r"[A-Za-z0-9]", rest):
            return None
        return mark
    return None


def is_doc(run, mark, tagged, end):
    if mark != "//":
        return False
    if all(entry[1].startswith("///") for entry in run):
        return True
    following = next((t[1] for t in tagged[end:] if t[1]), "")
    return bool(DOC_DECL.match(following))


def block_span(tagged, idx):
    mark = tagged[idx][0]
    closer = BLOCK_CLOSE[mark]
    if closer in tagged[idx][1][len(mark):]:
        return 1
    for offset in range(idx + 1, len(tagged)):
        if closer in tagged[offset][1]:
            return offset - idx + 1
    return None


def scan(path, before, after):
    marks = markers(path)
    if not marks:
        return []
    known = {line.strip() for line in before.splitlines()}
    tagged = []
    for raw in after.splitlines():
        text = raw.strip()
        tagged.append((marker_of(text, marks), text, text not in known))

    hits = []
    for idx, (mark, text, is_new) in enumerate(tagged):
        if not is_new or mark not in BLOCK_CLOSE:
            continue
        span = block_span(tagged, idx)
        if span == 1:
            continue
        limit = DOC_LIMIT if text.startswith("/**") else 1
        if span is None or span > limit:
            hits.extend(t[1] for t in tagged[idx:idx + (span or 1)])

    start = 0
    while start < len(tagged):
        mark = tagged[start][0]
        if mark is None or mark in BLOCK_CLOSE:
            start += 1
            continue
        end = start
        while end < len(tagged) and tagged[end][0] == mark:
            end += 1
        run = tagged[start:end]
        limit = DOC_LIMIT if is_doc(run, mark, tagged, end) else 1
        if len(run) > limit and any(entry[2] for entry in run):
            hits.extend(entry[1] for entry in run)
        start = end
    return hits


def reason(path, hits):
    listing = "\n".join("    " + h for h in hits[:12])
    if len(hits) > 12:
        listing += "\n    ... and %d more" % (len(hits) - 12)
    return (
        "BLOCKED \u2014 no multi-line comments. This edit puts a multi-line comment into "
        "%s:\n\n%s\n\nOne standalone comment line is allowed. Two or more adjacent comment "
        "lines, and any block comment spanning more than one line, are not. Deleting "
        "comments is always allowed. Doc comments a build step consumes \u2014 C# ///, "
        "JSDoc /** */, and Go // above an exported declaration \u2014 may run to %d lines "
        "before they are blocked too.\n\n"
        "Code is documented by unit tests, not comments. Collapse it to a single line or "
        "delete it \u2014 if it cannot survive on one line it does not belong in the file, it "
        "belongs in a unit test. Rulebook: %s\n\n"
        "If this is a false positive \u2014 a string literal, generated code, or a genuine "
        "keeper \u2014 do NOT retry. Tell the user what you hit and let them decide."
    ) % (path, listing, DOC_LIMIT, CRITERIA)


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
    hits = scan(path, before, after)
    if not hits:
        return
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason(path, hits),
    }}, sys.stdout)


main()
