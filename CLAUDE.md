# Agent Working Preferences

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. No Unsolicited Markdown Files

Do not create markdown files for thoughts, analyses, or documentation unless explicitly requested. If you must write unsolicited content, put it in `.thoughts/agents/` (gitignored). Don't create: README.md, NOTES.md, PLAN.md, or any documentation without being asked.

## 2. Planning Without Fluff

Implementation steps only — no time estimates, costs, docs, or deploy steps. Bad: `1. Implement X (2 hrs), 2. Write docs, 3. Deploy` Good: `1. Implement X, 2. Write tests`

## 3. Task Structure

Tasks are self-contained, testable units of work. Structure as code:

```
title: "Add login endpoint"
goal: Allow email/password auth with JWT tokens
context: Express.js/TypeScript, User model in src/models/User.ts, follow src/routes/api.ts pattern
steps:
  1. Create src/routes/auth.ts → verify: POST returns JWT
  2. Test invalid credentials → verify: 401 returned
cannot_close_until: all verifications pass
```

Provide enough context that an agent with zero prior knowledge could complete the task.

## 4. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 5. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 6. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code or formatting (comments are the exception — see §8).
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 7. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 8. No Comment Noise

**Code is documented by unit tests, not comments.**

- Do not narrate what you are doing or thinking in comments. No "// Loop through the users", "// Now we handle the error case", "// This fixes the bug by...".
- Do not leave breadcrumbs for the reviewer ("// Added per request", "// Changed from X to Y").
- When you encounter existing comments in code you are working on, actively remove them (exception to §6's "don't touch adjacent code" rule).
- The rare acceptable comment states a non-obvious constraint the code cannot express (e.g. a workaround for an upstream bug, with a link). Everything else: delete.
- If behavior needs explaining, write a unit test that demonstrates it instead.

## 9. Branching Off Master

When I say "create a new branch off of master" (or main), it means **exactly** this sequence — do not branch from wherever HEAD happens to be:

```
git checkout master      # (or main)
git pull                  # update to latest origin/master
git checkout -b <feature-branch>
```

Never use `git checkout -b <branch> origin/master` or `--track`: that sets the new branch's upstream to `origin/master`, which is wrong and dangerous (a bare `git push`/`pull` then targets shared master). A feature branch must track its **own** remote: set it on first push with `git push -u origin <feature-branch>`.

## 10. Load Secrets from .envrc

If secrets or environment variables cannot be found during execution, check for local `.envrc` files and load them into your shell session.

Use `source .envrc` or direnv to load environment variables before running commands that need them.

## 11. Local Tooling

- **mise** (`mise.toml`) manages tool versions and project tasks — prefer it over Makefiles. Run tasks with `mise run <task>`.
- **direnv** (`.envrc`) manages per-project env vars/secrets, auto-loaded on `cd` (see #10).