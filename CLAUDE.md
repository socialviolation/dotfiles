# Claude AI Dotfiles Management Guide

## Repository Purpose

This is a dotfiles repository managed with [yadm](https://yadm.io/). Files in this repository are deployed to the user's home directory (`~`) on their systems.

## How This Repository Works

- **Git Repository**: `${HOME}/dev/dotfiles` - This is where you (AI) should make edits
- **Deployment**: Files are deployed to `~` using `yadm`
- **Remote**: `git@github.com:socialviolation/dotfiles.git`

## AI Workflow for Editing Dotfiles

### 1. Before Making Any Edits

**ALWAYS check for local changes first:**

```bash
cd ${HOME}/dev/dotfiles
yadm diff
```

If there are changes in the yadm working tree (user's home directory), you MUST:
1. Review the changes carefully
2. Determine if they should be preserved
3. Either merge them into your edits or discuss with the user before proceeding

**NEVER blindly overwrite local changes without checking first.**

### 2. Making Edits

Edit files in `${HOME}/dev/dotfiles`:
- Use Read/Edit/Write tools on files in this directory
- Make all changes here, NOT in `~/.config/` or other home directory locations
- Commit changes using standard git commands

### 3. After Editing

Once changes are committed and pushed:

```bash
# User will run this to apply changes to their system
yadm pull
```

Or if conflicts exist:
```bash
yadm reset --hard origin/master  # Only if user approves losing local changes
```

## Key Files and Their Purpose

### Bootstrap
- `.config/yadm/bootstrap` - Installation script that runs after `yadm clone`
- Installs: zsh, powerlevel10k, zsh plugins, fzf, zoxide, mise, python, uv, direnv

### Shell Configuration
- `.zshrc` - Main zsh configuration
- `.zshrc.user` - User-specific overrides (not tracked, loaded by `.zshrc`)
- `.p10k.zsh` - Powerlevel10k theme configuration

### Development Tools
- `.gitconfig` - Git configuration
- `.gitconfig.user` - User-specific git config (not tracked, included by `.gitconfig`)
- `.tmux.conf` - Tmux configuration
- `.config/nvim/` - Neovim/LazyVim configuration
- `.config/alacritty/alacritty.toml` - Alacritty terminal config

### OS-Specific Files
- `.Brewfile##os.Darwin` - macOS Homebrew packages (only deployed on macOS)
- Files with `##os.Darwin` suffix are macOS-only
- Files with `##os.Linux` suffix are Linux-only

## Important Notes

1. **Check yadm diff before editing** - User may have made local changes
2. **Work in `${HOME}/dev/dotfiles`** - Never edit files directly in `~`
3. **Platform-specific files** - Use yadm alternates syntax (`##os.Darwin`, `##os.Linux`)
4. **Symlinks are handled by yadm** - Don't create manual symlinks
5. **Bootstrap is idempotent** - Can be run multiple times safely

## Common Commands Reference

```bash
# Check what's different between repo and home directory
yadm diff

# See status of tracked files in home directory
yadm status

# Pull latest changes from repo to home directory
yadm pull

# Force overwrite home directory with repo version
yadm reset --hard origin/master

# Add and commit changes from home directory to repo
yadm add <file>
yadm commit -m "message"
yadm push
```

## Package Managers

- **Arch/yay**: Primary package manager (checks for `yay` first, falls back to `pacman`)
- **apt**: Debian/Ubuntu support
- **dnf**: Fedora support
- **Homebrew**: macOS only (via Brewfile)

## Template for Making Changes

```bash
# 1. Check for local changes
cd ${HOME}/dev/dotfiles
yadm diff

# 2. If there are changes, review and decide:
#    - Merge them into your edits
#    - Ask user if they should be discarded
#    - Commit them first before proceeding

# 3. Make your edits in ${HOME}/dev/dotfiles
# (use Read/Edit/Write tools)

# 4. Commit and push
git add <files>
git commit -m "Descriptive message"
git push

# 5. User applies changes
yadm pull
```

## Red Flags - When to STOP and Ask

- `yadm diff` shows uncommitted changes
- User mentions files aren't updating after yadm pull
- Conflicts during yadm pull
- Files appearing in home directory that shouldn't be there
- OS-specific files appearing on wrong OS

Always prioritize preserving user data over applying your changes.
