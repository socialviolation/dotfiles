---
description: Intelligently merge changes from yadm home directory into dotfiles repo
allowed-tools: [Bash, Read, Edit, Write]
---

# Dotfiles Merge Command

You need to merge changes from the user's home directory (managed by yadm) into this dotfiles repository.

## Steps to Follow:

1. **Check for differences**:
   ```bash
   cd ${HOME}/dev/dotfiles
   yadm diff
   ```

2. **Analyze each changed file**:
   - Read the diff output carefully
   - Identify what changed and why
   - Check if files are platform-specific (##os.Darwin, ##os.Linux)

3. **For each modified file**:
   - If it's a platform-specific file (e.g., `.Brewfile##os.Darwin`), only merge if the change makes sense for that platform
   - If it's auto-generated (e.g., `lazy-lock.json`), you can usually copy it directly
   - If it's a config file with user changes, merge intelligently:
     - Preserve intentional user customizations
     - Don't duplicate settings
     - Maintain consistent formatting
     - Ask the user if you're unsure about a change

4. **Apply changes**:
   - Copy changes from `~` to `${HOME}/dev/dotfiles` using Edit/Write tools
   - For new files: `cp ~/.config/example ${HOME}/dev/dotfiles/.config/example`
   - For modifications: Use Edit tool to update files in the repo

5. **Platform-specific considerations**:
   - Check current OS: `uname -s` (Linux or Darwin for macOS)
   - Files with `##os.Darwin` should only be updated if changes came from a macOS system
   - Files with `##os.Linux` should only be updated if changes came from a Linux system
   - If a platform-specific file changed on the wrong platform, warn the user

6. **Verify and report**:
   - Show a summary of what was merged
   - List any files that were skipped and why
   - Recommend running `git status` to review changes before committing

## Important Warnings:

- **NEVER blindly overwrite repo files** - always understand what changed first
- **Auto-generated files** (like `lazy-lock.json`) can usually be copied directly
- **User config files** require careful merging to preserve customizations
- **Platform-specific files** should only be updated from the correct platform
- If unsure about any change, **ASK THE USER** before proceeding

## After Merging:

Remind the user to:
1. Review changes with `git diff` in the dotfiles repo
2. Commit changes: `git add -A && git commit -m "Merge host changes"`
3. Push to remote: `git push`
