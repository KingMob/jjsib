---
id: jjs-ztc6
status: closed
deps: [jjs-7gp8]
links: []
created: 2026-02-01T11:58:34Z
type: docs
priority: 2
assignee: Matthew Davidson
---
# Add README.md for GitHub distribution

Create comprehensive README with these sections:

## Sections

1. **Overview** - One-liner: manage jj workspaces as sibling directories
2. **Why sibling workspaces?** - Cleaner navigation, easier IDE setup, no nested paths
3. **Requirements** - jj (required), gum (optional for interactive selection)
4. **Installation** - Two methods:
   - curl one-liner: `curl -fsSL <url> -o ~/bin/jj-worksib.sh && chmod +x ~/bin/jj-worksib.sh`
   - Manual: clone repo, copy script to PATH
5. **Shell Setup** - Exact eval lines to add to rc files:
   ```bash
   # Bash (~/.bashrc)
   eval "$(jj-worksib.sh hook bash)"

   # Zsh (~/.zshrc)
   eval "$(jj-worksib.sh hook zsh)"

   # Fish (~/.config/fish/config.fish)
   jj-worksib.sh hook fish | source
   ```
6. **Quick Start** - Example workflow:
   - `jjsib init` - initialize in existing repo
   - `jjsib add feature-x` - create sibling workspace
   - `jjsib switch feature-x` - change to it
   - `jjsib list` - see all workspaces
7. **Commands** - All modes with brief examples
8. **Configuration** - `.workspace-init.sh` auto-execution hook

