# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

jjsib (jj-worksib.sh) is a bash script that manages sibling Jujutsu (jj) workspaces at the same directory level as the current repository. It creates workspaces as sibling directories rather than subdirectories.

## Commands

```bash
# Run the script directly
./jj-worksib.sh <mode> [args]

# Test with shellcheck
shellcheck jj-worksib.sh

# Modes: init, add, remove, switch, rename, list, hook, help
```

## Architecture

Single self-contained bash script with no external dependencies beyond `jj` and optionally `gum` (for interactive selection).

**Key design patterns:**
- Uses `set -euo pipefail` for strict error handling
- Shell function output via `hook` mode - the `jjsib` shell function wraps the script and `eval`s `cd` commands for directory switching
- Shell completions for bash, zsh, and fish embedded in `hook` mode output
- Optional `.workspace-init.sh` script runs automatically after workspace creation

**Mode dispatch:** Single `case` statement validates arguments, second `case` statement executes mode logic.

## Tickets

Use `tk` for tracking work. Tickets are stored in `.tickets/` as markdown files.

```bash
tk create "Title" -t feature -d "Description"  # Create ticket
tk ls                                           # List open tickets
tk start <id>                                   # Mark in progress
tk close <id>                                   # Mark complete
tk show <id>                                    # View details
```
