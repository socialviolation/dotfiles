import json
import os
import subprocess

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "no-comments.py")


def edit(path, old, new):
    payload = {"hook_event_name": "PreToolUse", "tool_name": "Edit",
               "tool_input": {"file_path": path, "old_string": old, "new_string": new}}
    out = subprocess.run([HOOK], input=json.dumps(payload), capture_output=True, text=True)
    assert out.returncode == 0, out.stderr
    return bool(out.stdout.strip())


CASES = [
    ("single py comment",        False, ("a.py",  "x=1",              "# set the flag\nx=1")),
    ("single ts comment",        False, ("a.ts",  "f()",              "// bail early\nf()")),
    ("single-line block",        False, ("a.ts",  "f()",              "/* bail early */\nf()")),
    ("trailing comment",         False, ("a.py",  "x=1",              "x=1  # flag")),

    ("two py comments",          True,  ("a.py",  "x=1",              "# set flag\n# then use it\nx=1")),
    ("two ts comments",          True,  ("a.ts",  "f()",              "// step one\n// step two\nf()")),
    ("jsdoc block",              True,  ("a.js",  "f()",              "/**\n * @param id the id\n */\nf()")),
    ("unterminated block",       True,  ("a.go",  "p()",              "/* why we do this\n   and more */\np()")),
    ("html comment block",       True,  ("a.html","<p>",              "<!-- the header\n     bit -->\n<p>")),
    ("two sql dashes",           True,  ("a.sql", "select 1",         "-- grab rows\n-- from the table\nselect 1")),
    ("two vim quotes",           True,  ("a.vim", "set nu",           '" leader key\n" set below\nset nu')),
    ("two latex percents",       True,  ("a.tex", "\\doc",            "% preamble\n% and fonts\n\\doc")),
    ("unknown ext two hashes",   True,  ("a.mylang", "x=1",           "# do the thing\n# then this\nx=1")),
    ("append to existing block", True,  ("a.py",  "# one\n# two\nx=1","# one\n# two\n# three\nx=1")),
    ("reword line in block",     True,  ("a.py",  "# one\n# two\nx=1","# one\n# TWO NOW\nx=1")),

    ("delete whole block",       False, ("a.py",  "# one\n# two\nx=1","x=1")),
    ("delete one of two",        False, ("a.py",  "# one\n# two\nx=1","# one\nx=1")),
    ("sh long-flag continuation",False, ("a.sh",  "curl x",           "curl \\\n  --silent \\\n  --fail")),
    ("unknown ext long flags",   False, ("run",   "curl x",           "curl \\\n  --silent \\\n  --fail")),
    ("two-line license",         False, ("a.go",  "p()",              "// Copyright 2026 Nick\n// Licensed MIT\np()")),
    ("url keepers",              False, ("a.py",  "x=1",              "# see https://bugs/1\n# see https://bugs/2\nx=1")),
    ("noqa breaks the run",      False, ("a.py",  "import os",        "# needed\nimport os  # noqa: F401")),
    ("shebang plus one",         False, ("a.sh",  "echo",             "#!/usr/bin/env bash\n# run it\necho")),
    ("yaml is config",           False, ("a.yml", "a: 1",             "# the setting\n# and more\na: 1")),
    ("markdown untouched",       False, ("a.md",  "hi",               "# Heading\n# Another\nhi")),
    ("json untouched",           False, ("a.json","{}",               '{"a":1}')),
    ("go pointer derefs",        False, ("a.go",  "x",                "*p = 5\n*q = 6")),
    ("no comments at all",       False, ("a.py",  "x=1",              "x=1\ny=2")),
]

fails = 0
for name, want, args in CASES:
    got = edit(*args)
    ok = got == want
    fails += not ok
    print("%-28s want=%-5s got=%-5s %s" % (name, want, got, "ok" if ok else "FAIL"))
print("\n%d/%d passed" % (len(CASES) - fails, len(CASES)))
raise SystemExit(1 if fails else 0)
