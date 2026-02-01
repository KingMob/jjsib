---
id: jjs-4qpo
status: open
deps: []
links: []
created: 2026-02-01T12:45:46Z
type: feature
priority: 2
assignee: Matthew Davidson
---
# Build test suite for jjsib

Create a test suite that exercises jjsib functionality in isolated temporary jj repositories.

## Requirements
- Tests run in a temporary directory outside the jjsib repo
- Each test creates a fresh jj repo for isolation
- Clean up temp directories after tests

## Initial Test Cases
- [ ] Verify auto-sync renames workspace to match directory name when mismatched
- [ ] Verify no action taken when workspace name already matches directory

## Technical Notes
- Use bash test framework (bats) or simple shell script with assertions
- Script should be runnable via `./test.sh` or similar
- Exit non-zero on any test failure

