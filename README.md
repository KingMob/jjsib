# jjsib

[![GitHub](https://img.shields.io/github/license/KingMob/jjsib)](https://github.com/KingMob/jjsib)

Manage Jujutsu (jj) workspaces as sibling directories.

## About

**jjsib** is a tool to add/remove/configure/switch between workspaces at the same directory level as your main repo:

```
~/code/
├── myproject/        # main workspace
├── myproject-feature-x/   # sibling workspace
└── myproject-hotfix/      # another sibling
```

I considered subdirectories (like `./.workspaces/`), but I wanted to avoid any
issues with ignore patterns or tools that search up the directory tree.

## Requirements

- [**Jujutsu (jj)**](https://www.jj-vcs.dev/latest/) - required, obviously
- [**Gum**](https://github.com/charmbracelet/gum) - optional, but makes nice interactive selection menus if you don't provide a workspace name

All workspace names must match their directory names, since jj does not (currently) have a way to map workspaces to directories. Workspaces are automatically synced to match their directory names when using jjsib. NB: This means that jjsib will rename the primary `default` workspace to the directory name on first use.

## Install

### 1. Download

```bash
JJSIB_INSTALL_DIR="$HOME/.local/bin"; curl -fsSL https://raw.githubusercontent.com/KingMob/jjsib/main/jj-worksib.sh -o "$JJSIB_INSTALL_DIR/jj-worksib.sh" && chmod +x "$JJSIB_INSTALL_DIR/jj-worksib.sh"
```

### 2. Shell Setup

Add these to your shell configurations for the `jjsib` function and shell 
completions, then start a new shell.

Note that the `jjsib` shell function is **required** to switch between workspaces, 
since scripts can't alter your working directory. (You don't typically run `jj-worksib.sh` directly.)

**Bash** (`~/.bashrc`):
```bash
eval "$(jj-worksib.sh hook bash)"
```

**Zsh** (`~/.zshrc`):
```zsh
eval "$(jj-worksib.sh hook zsh)"
```

**Fish** (`~/.config/fish/config.fish`):
```fish
jj-worksib.sh hook fish | source
```

This provides the `jjsib` command with directory switching and shell completions.

## Usage

```bash
# Create a new workspace with @ as the parent
jjsib add feature-x

# Create workspace with main bookmark as the parent
jjsib add feature-auth main

# Switch to a workspace 
jjsib switch bugfix-y

# Interactive switch (requires gum)
jjsib switch

# List all workspaces
jjsib list

# Remove when done
jjsib forget feature-x
```

## Commands

| Command | Description |
|---------|-------------|
| `jjsib help` | Show help |
| `jjsib add <name> [parent revset]` | Create sibling workspace (default: current revision) |
| `jjsib switch [name]` | Switch to workspace (interactive if no name given) |
| `jjsib forget [name]` | Forget and delete workspace (interactive if no name) |
| `jjsib rename <old> <new>` | Rename workspace and its directory |
| `jjsib list` | List all workspaces |
| `jjsib version` | Show version |

**Aliases:** `create`=>`add`, `rm`,`remove`=>`forget`, `sw`=>`switch`, `ls`=>`list`

## Workspace Initialization

If a file named `.workspace-init.sh` exists in a newly created workspace, it 
runs automatically in the new workspace after creation. Use this for:

- Marking as trusted (direnv, mise, etc.)
- Installing dependencies
- Creating workspace-specific files (e.g., `.env.local`)

**Example** `.workspace-init.sh`:
```bash
#!/bin/bash

mise trust --quiet
pnpm install
```
