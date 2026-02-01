#!/usr/bin/env bats

load 'test_helper/common'

# Tests for add/create mode

@test "add creates sibling workspace" {
    run_jjsib add feature-one

    [ "$status" -eq 0 ]
    [[ "$output" == *"Successfully created sibling workspace"* ]]

    # Verify sibling directory exists
    [ -d "${TEST_TEMP_DIR}/feature-one" ]

    # Verify it's a jj workspace
    [ -d "${TEST_TEMP_DIR}/feature-one/.jj" ]
}

@test "create is an alias for add" {
    run_jjsib create feature-two

    [ "$status" -eq 0 ]
    [[ "$output" == *"Successfully created sibling workspace"* ]]
    [ -d "${TEST_TEMP_DIR}/feature-two" ]
}

@test "add with parent revset creates workspace at specified revision" {
    # Create a file and commit it
    echo "initial content" > file.txt
    jj commit -m "Initial commit"

    # Create workspace at @ (current revision)
    run_jjsib add feature-at @

    [ "$status" -eq 0 ]
    [ -d "${TEST_TEMP_DIR}/feature-at" ]
}

@test "add fails if directory already exists" {
    # Create a directory first
    mkdir -p "${TEST_TEMP_DIR}/existing-dir"

    run_jjsib add existing-dir

    [ "$status" -eq 1 ]
    [[ "$output" == *"already exists"* ]]
}

@test "add lists workspace in jj workspace list" {
    run_jjsib add new-workspace

    [ "$status" -eq 0 ]

    # Check workspace is listed
    run jj workspace list --ignore-working-copy
    [[ "$output" == *"new-workspace"* ]]
}

@test "add creates workspace with default parent @" {
    # Without specifying parent revset, it should default to @
    run_jjsib add default-parent

    [ "$status" -eq 0 ]
    [ -d "${TEST_TEMP_DIR}/default-parent" ]
}

@test "add runs .workspace-init.sh if present" {
    # Create the test file that init script will create
    echo '#!/bin/bash
cd "$(dirname "$0")" || exit 1
touch .init-ran' > "${TEST_REPO_DIR}/.workspace-init.sh"
    chmod +x "${TEST_REPO_DIR}/.workspace-init.sh"

    run_jjsib add workspace-with-init

    [ "$status" -eq 0 ]
    [[ "$output" == *"initialization script"* ]]

    # Check that the init script ran (created .init-ran file)
    [ -f "${TEST_TEMP_DIR}/workspace-with-init/.init-ran" ]
}

@test "add runs .jjsib-add-init.sh as fallback" {
    # Test backwards compatibility with old init script name
    echo '#!/bin/bash
cd "$(dirname "$0")" || exit 1
touch .legacy-init-ran' > "${TEST_REPO_DIR}/.jjsib-add-init.sh"
    chmod +x "${TEST_REPO_DIR}/.jjsib-add-init.sh"

    run_jjsib add workspace-with-legacy-init

    [ "$status" -eq 0 ]
    [[ "$output" == *"initialization script"* ]]

    # Check that the init script ran
    [ -f "${TEST_TEMP_DIR}/workspace-with-legacy-init/.legacy-init-ran" ]
}

@test "add prefers .workspace-init.sh over .jjsib-add-init.sh" {
    # Create both init scripts
    echo '#!/bin/bash
cd "$(dirname "$0")" || exit 1
touch .new-init-ran' > "${TEST_REPO_DIR}/.workspace-init.sh"
    chmod +x "${TEST_REPO_DIR}/.workspace-init.sh"

    echo '#!/bin/bash
cd "$(dirname "$0")" || exit 1
touch .legacy-init-ran' > "${TEST_REPO_DIR}/.jjsib-add-init.sh"
    chmod +x "${TEST_REPO_DIR}/.jjsib-add-init.sh"

    run_jjsib add workspace-prefer-new

    [ "$status" -eq 0 ]

    # Only new init should have run
    [ -f "${TEST_TEMP_DIR}/workspace-prefer-new/.new-init-ran" ]
    [ ! -f "${TEST_TEMP_DIR}/workspace-prefer-new/.legacy-init-ran" ]
}

@test "add fails if init script fails" {
    echo '#!/bin/bash
exit 1' > "${TEST_REPO_DIR}/.workspace-init.sh"
    chmod +x "${TEST_REPO_DIR}/.workspace-init.sh"

    run_jjsib add workspace-failing-init

    [ "$status" -eq 1 ]
    [[ "$output" == *"Initialization script failed"* ]]
}

@test "add creates multiple sibling workspaces" {
    run_jjsib add ws1
    [ "$status" -eq 0 ]

    run_jjsib add ws2
    [ "$status" -eq 0 ]

    run_jjsib add ws3
    [ "$status" -eq 0 ]

    # All should exist
    [ -d "${TEST_TEMP_DIR}/ws1" ]
    [ -d "${TEST_TEMP_DIR}/ws2" ]
    [ -d "${TEST_TEMP_DIR}/ws3" ]

    # All should be in workspace list
    run jj workspace list --ignore-working-copy
    [[ "$output" == *"ws1"* ]]
    [[ "$output" == *"ws2"* ]]
    [[ "$output" == *"ws3"* ]]
}
