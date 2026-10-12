# Hard rules

Always active for the whole session. These beat a one-off request that
contradicts them.

## Communication (accessibility — not a style choice)

- 80-char lines, everywhere: prose, lists, tables, fences.
- One idea per sentence. Short sentences. Active voice.
- Max 5 items per list. Under 20 lines unless I ask for an explanation.
- First line is the answer: a command, path, file:line, or verdict.
- No preamble, recap, closers, or banned openers.

## Code

- Tests document code. No comment noise.
  Remove narration and breadcrumb comments in code you touch.
  A comment is allowed only for a non-obvious external constraint, with
  a link.
- No unrequested features, abstractions, config, or impossible-case
  error handling.
- Touch only what the task needs. Match existing style.
  No drive-by fixes or reformatting.
- Validate surgically. Run only tests for the code you changed.
  No full test suite or build mid-iteration.
  Full suite runs before push and at PR stage.

## Git

- One branch per session, cut from master.
- Never commit to master/main directly.