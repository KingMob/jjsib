---
id: jjs-dlkp
status: closed
deps: []
links: []
created: 2026-02-01T13:19:44Z
type: feature
priority: 2
assignee: Matthew Davidson
---
# Write auto-sync tests

Create tests/auto_sync.bats with two test cases:

**Test 1: "auto-sync renames workspace when directory name mismatches"**
- jj init creates workspace "default", directory is "test-repo"
- Run run_jjsib list
- Assert success
- Assert workspace renamed to "test-repo"
- Assert output contains "Auto-synced"

**Test 2: "no auto-sync when workspace name already matches"**
- Manually jj workspace rename test-repo first
- Run run_jjsib list
- Assert success
- Assert output does NOT contain "Auto-synced"

Run mise run test to verify both pass.

Parent: jjs-4qpo
Depends on: jjs-g1cp
