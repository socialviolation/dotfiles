# Agent Working Preferences

Behavioral guidelines to reduce common LLM coding mistakes. These bias toward caution over speed — for trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code or formatting (comments are the exception — see §5).
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Notice unrelated dead code? Mention it — don't delete it.
- Remove imports/variables/functions that YOUR changes made unused.

The test: every changed line traces directly to the request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step work, state the plan as `step → verify:` pairs. Implementation steps only — no time estimates, costs, docs, or deploy steps.

## 5. No Comment Noise

**Code is documented by unit tests, not comments.**

- Don't narrate what you're doing in comments. No `// Loop through the users`, `// Now handle the error case`, `// This fixes the bug by...`.
- Don't leave breadcrumbs for the reviewer (`// Added per request`, `// Changed from X to Y`).
- Remove existing comments in code you're working on (exception to §3).
- The rare acceptable comment states a non-obvious constraint the code can't express — a workaround for an upstream bug, with a link. Everything else: delete.
- If behavior needs explaining, write a unit test instead.

## 6. Branching

**One branch per session, cut from master, named from Linear.**

Never commit to `master`/`main` directly. Create the session branch at the start:

```
git checkout master      # or main
git pull                 # update to latest origin/master
git checkout -b <linear-branch-name>
```

- Use Linear's generated branch name for the issue.
- Never `git checkout -b <branch> origin/master` or `--track` — that sets upstream to `origin/master`, so a bare `git push`/`pull` targets shared master. Set the branch's own upstream on first push: `git push -u origin <branch>`.
- **Never create a second branch in the same session.** Features are batched onto one branch; separate branches add too much testing overhead. If new work looks like it wants its own branch, keep it on the current one and say so.

## 7. Environment & Tooling

- **mise** (`mise.toml`) manages tool versions and project tasks — prefer it over Makefiles. Run tasks with `mise run <task>`.
- **direnv** (`.envrc`) holds per-project env vars and secrets. If a secret or env var is missing, `source .envrc` before rerunning.
- **devstack** manages local dev services. Don't start services by hand — use `devstack start <service>` (it handles dependency ordering) and `devstack status` to see what's running. Workspace is auto-detected from the working directory. When debugging a running service, query its traces and logs via `devstack otel traces` rather than guessing.
- **"The stack URL"** means the tailnet HTTPS URL, never the devstack port. This machine is `omarchy` on the tailnet, so URLs read `https://omarchy.tailde366c.ts.net:<port>`. Three hops, a different port at each: `tailnet :84xx → caddy :85xx → service :200xx`. Site blocks live in `~/dev/navexa/caddy/stacks/<stack>-<service>.caddy` (written by `scripts/stack-provision.sh`), so grepping the main `Caddyfile` for the service port finds nothing. Derive it:

  ```sh
  stack=orbit-store
  for f in ~/dev/navexa/caddy/stacks/${stack}-*.caddy; do
    cport=$(grep -oP '^:\K[0-9]+' "$f")
    tailscale serve status | grep -B1 "127.0.0.1:${cport}\b" | grep -oP 'https://\S+'
  done
  ```

  Read the ports; the `84xx/85xx/200xx` offsets are convention, not a rule. Never stand up a new `tailscale serve` — it bypasses caddy's compression and leaves a stray mapping. Never enable Funnel; every mapping is tailnet-only. A backend-only stack has no `.caddy` file, and "no URL" is then the correct answer.

## 8. Communication

**Lead with the action. No preamble, no recap, no closer.** Long status prose is not progress.

- First line is the answer — command, path, or snippet. Prose after, if at all.
- Number multi-step work. One bounded action per step.
- Restate position each turn: "Step 3 of 5 done: schema updated. Next: backfill."
- Cap lists at 5. Past that, split "now" vs "later" rather than listing ten unranked.
- Errors: state cause and fix. No "uh oh". Give `file:line`, expected vs actual.
- Time estimates in concrete units — "~15 min if tests cover this", never "some work".
- Finish the current thread before raising a second issue, then raise it as one question.
- Banned openers: "Great question", "Let me…", "I'll…", "Sure!", "Looking at your…". Banned closers: "Hope this helps", "Let me know if you need anything else".
- Don't state a cause you haven't verified — say "likely" and what would prove it. Scope claims to what you measured.
- No unsolicited markdown files (README, NOTES, PLAN). If unavoidable: `.thoughts/agents/` (gitignored).

**Exceptions:** "explain" or "walk me through" → run as long as the topic needs, with headers to skim. Destructive action → confirm first. Real ambiguity → one clarifying question.
