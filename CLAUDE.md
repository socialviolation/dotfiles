# Agent Working Preferences

Behavioral guidelines to reduce common LLM coding mistakes.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. No Unsolicited Markdown Files

Do not create markdown files for thoughts, analyses, or documentation unless explicitly requested. If you must write unsolicited content, put it in `.thoughts/agents/` (gitignored). Don't create: README.md, NOTES.md, PLAN.md, or any documentation without being asked.

## 2. Planning Without Fluff

Implementation steps only — no time estimates, costs, docs, or deploy steps. Bad: `1. Implement X (2 hrs), 2. Write docs, 3. Deploy` Good: `1. Implement X, 2. Write tests`

## 3. Bead Structure

Beads are self-contained, testable units of work. Structure as code:

```
title: "Add login endpoint"
goal: Allow email/password auth with JWT tokens
context: Express.js/TypeScript, User model in src/models/User.ts, follow src/routes/api.ts pattern
steps:
  1. Create src/routes/auth.ts → verify: POST returns JWT
  2. Test invalid credentials → verify: 401 returned
cannot_close_until: all verifications pass
```

Provide enough context that an agent with zero prior knowledge could complete the bead.

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
- Don't "improve" adjacent code, comments, or formatting.
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

## 8. Load Secrets from .envrc

If secrets or environment variables cannot be found during execution, check for local `.envrc` files and load them into your shell session.

Use `source .envrc` or direnv to load environment variables before running commands that need them.