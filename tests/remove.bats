#!/usr/bin/env bats

load 'test_helper/common'

# Tests for remove/rm mode

@test "remove deletes sibling workspace" {
    # First add a workspace
    run_jjsib add to-remove
    [ "$status" -eq 0 ]
    [ -d "${TEST_TEMP_DIR}/to-remove" ]

    # Now remove it
    run_jjsib remove to-remove

    [ "$status" -eq 0 ]
    [[ "$output" == *"Successfully deleted"* ]]

    # Directory should be gone
    [ ! -d "${TEST_TEMP_DIR}/to-remove" ]
}

@test "rm is an alias for remove" {
    run_jjsib add to-rm
    [ "$status" -eq 0 ]

    run_jjsib rm to-rm

    [ "$status" -eq 0 ]
    [ ! -d "${TEST_TEMP_DIR}/to-rm" ]
}

@test "remove forgets workspace from jj" {
    run_jjsib add will-forget
    [ "$status" -eq 0 ]

    # Verify workspace is listed
    run jj workspace list --ignore-working-copy
    [[ "$output" == *"will-forget"* ]]

    # Remove it
    run_jjsib remove will-forget
    [ "$status" -eq 0 ]

    # Verify workspace is no longer listed
    run jj workspace list --ignore-working-copy
    [[ "$output" != *"will-forget"* ]]
}

@test "remove cannot remove current workspace" {
    # Try to remove the current workspace (test-repo)
    run_jjsib remove test-repo

    [ "$status" -eq 1 ]
    [[ "$output" == *"Cannot remove the workspace you are currently in"* ]]

    # Directory should still exist
    [ -d "${TEST_REPO_DIR}" ]
}

@test "remove fails for non-existent workspace" {
    run_jjsib remove nonexistent-workspace

    [ "$status" -eq 1 ]
    [[ "$output" == *"does not exist"* ]]
}

@test "remove handles workspace with files" {
    run_jjsib add ws-with-files
    [ "$status" -eq 0 ]

    # Create some files in the workspace
    echo "test content" > "${TEST_TEMP_DIR}/ws-with-files/testfile.txt"
    mkdir -p "${TEST_TEMP_DIR}/ws-with-files/subdir"
    echo "nested" > "${TEST_TEMP_DIR}/ws-with-files/subdir/nested.txt"

    # Remove should still work
    run_jjsib remove ws-with-files

    [ "$status" -eq 0 ]
    [ ! -d "${TEST_TEMP_DIR}/ws-with-files" ]
}

@test "remove multiple workspaces sequentially" {
    run_jjsib add ws-a
    run_jjsib add ws-b
    run_jjsib add ws-c

    # Remove them one by one
    run_jjsib remove ws-a
    [ "$status" -eq 0 ]
    [ ! -d "${TEST_TEMP_DIR}/ws-a" ]

    run_jjsib remove ws-b
    [ "$status" -eq 0 ]
    [ ! -d "${TEST_TEMP_DIR}/ws-b" ]

    run_jjsib remove ws-c
    [ "$status" -eq 0 ]
    [ ! -d "${TEST_TEMP_DIR}/ws-c" ]
}
