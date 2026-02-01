#!/usr/bin/env bats

load 'test_helper/common'

# Tests for init mode

@test "init renames workspace to match directory name" {
    # jj init creates workspace "default" but directory is "test-repo"
    # Verify initial state (may have been auto-synced already)
    local initial_name
    initial_name=$(get_workspace_name)

    # Run init explicitly
    run_jjsib init

    [ "$status" -eq 0 ]
    [[ "$output" == *"Successfully renamed workspace"* ]] || [[ "$output" == *"test-repo"* ]]

    # Verify workspace name matches directory
    local workspace_name
    workspace_name=$(get_workspace_name)
    [ "$workspace_name" = "test-repo" ]
}

@test "init is idempotent - running twice succeeds" {
    # First init
    run_jjsib init
    [ "$status" -eq 0 ]

    # Second init should also succeed
    run_jjsib init
    [ "$status" -eq 0 ]

    # Workspace name should still be correct
    local workspace_name
    workspace_name=$(get_workspace_name)
    [ "$workspace_name" = "test-repo" ]
}

@test "init handles repo in directory with special chars in name" {
    # Create a new repo in a directory with hyphens
    local special_dir="${TEST_TEMP_DIR}/my-test-repo-123"
    mkdir -p "$special_dir"
    cd "$special_dir"
    jj git init --colocate

    run_jjsib init

    [ "$status" -eq 0 ]

    local workspace_name
    workspace_name=$(get_workspace_name)
    [ "$workspace_name" = "my-test-repo-123" ]
}
