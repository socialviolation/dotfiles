---
description: Sync dotfiles repo changes to host system via yadm
allowed-tools: [Bash, Read, Grep, Glob]
---

# Dotfiles Sync Command

Sync changes from this dotfiles repository to the host system.

## Steps to Follow:

### 1. Pre-sync Verification
Check if there are uncommitted changes in the dotfiles repo:
```bash
cd ${HOME}/dev/dotfiles
git status
```

If there are uncommitted changes, show them to the user and ask if they want to proceed with committing.

### 2. Commit and Push Changes
```bash
cd ${HOME}/dev/dotfiles
git add -A
git status  # Show what will be committed
```

Ask the user for a commit message, or generate a concise one based on the changes.

```bash
git commit -m "commit message here"
git push
```

If the push fails (e.g., behind remote), inform the user and STOP. Don't force push.

### 3. Pull Changes to Home Directory
```bash
yadm pull
```

If there are merge conflicts:
- Show the conflicts to the user
- Ask if they want to force overwrite with `yadm reset --hard origin/master`
- Or if they want to manually resolve conflicts first
- **NEVER force reset without user confirmation**

### 4. Final Report

Provide a summary:
- ✅ Changes committed and pushed
- ✅ yadm pull completed successfully
- 💡 Reminder: Restart your shell if .zshrc changed

## Error Handling:

**If git push fails:**
- Check if behind remote: suggest `git pull --rebase`
- Check if authentication failed: suggest checking SSH keys
- Never force push without explicit user permission

**If yadm pull fails:**
- Show the error message
- Check for conflicts with `yadm status`
- Ask user how to proceed

## Post-sync Recommendations:

After successful sync, remind the user:
1. **Restart shell** if `.zshrc` or shell configs changed: `exec zsh`
2. **Reload tmux config** if `.tmux.conf` changed: `tmux source-file ~/.tmux.conf`
3. **Sync nvim plugins** if nvim configs changed: Open nvim and run `:Lazy sync`
4. **Reload alacritty** if terminal config changed: No action needed (auto-reloads)

## Safety Checks:

- **NEVER** force push without user confirmation
- **NEVER** run `yadm reset --hard` without user confirmation
- **ALWAYS** show what will be committed before committing
- **ALWAYS** show errors clearly and ask for guidance
- If anything looks wrong, **ASK THE USER** before proceeding
