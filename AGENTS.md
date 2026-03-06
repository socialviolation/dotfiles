# Agent Working Preferences

This document outlines how I prefer to work with AI agents.

## Rule #1: No Unsolicited Markdown Files

**DO NOT create markdown files for random thoughts, analyses, or documentation unless explicitly requested.**

If you feel compelled to write down thoughts, analysis, or documentation that was NOT requested:
- Put it in `.thoughts/agents/` directory
- These files are intentionally ignored by git
- These files are generally NOT seen as an asset
- They are throwaway scratchpad content

### What This Means:

- ❌ DON'T create README.md, NOTES.md, PLAN.md, etc. without being asked
- ❌ DON'T create documentation "to be helpful"
- ❌ DON'T write analysis files unless requested
- ✅ DO put any unsolicited thoughts in `.thoughts/agents/` if you must write them
- ✅ DO ask if I want documentation before creating it

### The `.thoughts/agents/` Directory:

This directory is for throwaway content only:
- It's in .gitignore - intentionally not tracked
- Files here are not considered valuable
- Use it as a scratchpad if you need to organize thoughts
- Don't expect these files to be referenced later
- They will likely be deleted

## Rule #2: Planning Without Fluff

When creating any kind of plan, **DO NOT include** the following unless explicitly requested:

### Never Include (Unless Asked):

- ❌ **Time estimates** - No "this will take 2 hours" or "sprint planning"
- ❌ **Cost estimates** - No budget projections or resource calculations
- ❌ **Documentation as a deliverable** - Don't plan to write docs unless I ask for it
- ❌ **Deployment steps** - Don't include deployment in feature plans
- ❌ **CI/CD pipeline work** - Don't add CI/CD tasks unless I ask

### What This Means:

When I ask you to plan a feature:
- ✅ DO focus on the actual implementation steps
- ✅ DO break down the technical work required
- ✅ DO identify dependencies and order of operations
- ❌ DON'T add "write documentation" as a step
- ❌ DON'T add "set up deployment" as a step
- ❌ DON'T add "configure CI/CD" as a step
- ❌ DON'T estimate how long anything will take

### Example:

**Bad Plan:**
1. Implement feature X (2-3 hours)
2. Write unit tests (1 hour)
3. Write documentation (30 minutes)
4. Set up CI/CD pipeline
5. Deploy to staging
6. Total: ~7 hours, estimated cost: $200

**Good Plan:**
1. Implement feature X
2. Write unit tests

Keep it simple. Focus on the code work. Nothing else unless I ask.

## Rule #3: Structuring Work into Beads

When breaking work into beads (conversation threads), each bead **MUST** include:

### Required Information for Each Bead:

1. **Goal of the feature** - What are we building and why?
2. **Project context** - How does this tie into the overall project?
3. **Verification criteria** - How can we verify the work is complete by testing the running code?

### Critical Rules:

- ✅ **Break work into testable chunks** - Each bead should be a testable unit of work
- ✅ **Define verification steps** - Include specific ways to test the running code
- ✅ **Test before closing** - Beads CANNOT be closed until the work has been tested
- ❌ **No untestable beads** - Don't create beads that can't be verified by running code

### What This Means:

Each bead should answer:
- What are we building?
- Why does this matter to the project?
- How do we know it works? (actual test/verification steps)

### Example:

**Bad Bead:**
- Title: "Add user authentication"
- Work: Implement auth system
- (No context, no verification, too broad)

**Good Bead:**
- Title: "Add login endpoint with JWT tokens"
- Goal: Allow users to authenticate via email/password and receive JWT tokens
- Context: This is the first step in our authentication system, which will eventually support OAuth and 2FA
- Verification:
  - Start the server
  - POST to /api/login with valid credentials
  - Verify we receive a valid JWT token
  - Verify token can be decoded and contains user ID
  - Test with invalid credentials returns 401
- Status: Cannot close until all verification steps pass

**Remember:** If you can't test it, the bead isn't done. If you can't verify it works, don't close the bead.

## Summary

If I didn't ask for a markdown file, don't create one. If you absolutely must write something down, use `.thoughts/agents/` and understand it's throwaway content.

When planning, focus on implementation only - no time/cost estimates, no documentation deliverables, no deployment/CI/CD work unless explicitly requested.
