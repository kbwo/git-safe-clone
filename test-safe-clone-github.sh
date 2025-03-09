#!/bin/bash

set -u

# Test script for git-safe-clone with GitHub repositories
# This script tests if git-safe-clone can detect potentially dangerous code in GitHub repositories

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repositories to test
DANGEROUS_REPO="https://github.com/kbwo/git-safe-clone-test-dangerous-repo"
STEALTH_REPO="https://github.com/kbwo/git-safe-clone-test-stealth-js"
SAFE_REPO="https://github.com/kbwo/dotfiles"

# Function to print colored messages
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Function to clean up test directories
cleanup() {
    local repo_name="$1"
    print_message "$YELLOW" "Cleaning up test directory: $repo_name"
    rm -rf "./$repo_name" 2>/dev/null
    print_message "$GREEN" "Cleanup completed."
}

# Function to run a test case
run_test() {
    local test_name="$1"
    local repo_url="$2"
    local expected_result="$3" # "safe" or "unsafe"
    local repo_name=$(basename "$repo_url")

    print_message "$BLUE" "========================================"
    print_message "$BLUE" "Running test: $test_name"
    print_message "$BLUE" "Repository: $repo_url"
    print_message "$BLUE" "Expected result: $expected_result"
    print_message "$BLUE" "========================================"

    # Ensure we start with a clean state
    cleanup "$repo_name"

    # Run git-safe-clone
    print_message "$YELLOW" "Running git-safe-clone..."
    ./git-safe-clone "$repo_url" "$repo_name"

    # Check the result
    if [ "$expected_result" == "safe" ]; then
        if [ -d "./$repo_name" ]; then
            print_message "$GREEN" "TEST PASSED: Repository was correctly identified as safe."
            return 0
        else
            print_message "$RED" "TEST FAILED: Repository was incorrectly identified as unsafe."
            return 1
        fi
    else # expected_result == "unsafe"
        if [ -d "./$repo_name" ]; then
            print_message "$RED" "TEST FAILED: Repository was incorrectly identified as safe."
            return 1
        else
            print_message "$GREEN" "TEST PASSED: Repository was correctly identified as unsafe."
            return 0
        fi
    fi
}

# Main function
main() {
    print_message "$YELLOW" "Starting git-safe-clone GitHub repository tests..."

    # Run test with the dangerous repository
    run_test "Dangerous Repository Test" "$DANGEROUS_REPO" "unsafe"
    local dangerous_test_result=$?

    # Run test with the stealth repository
    run_test "Stealth Repository Test" "$STEALTH_REPO" "unsafe"
    local stealth_test_result=$?

    # Run test with the safe repository
    run_test "Safe Repository Test" "$SAFE_REPO" "safe"
    local safe_test_result=$?

    # Print overall results
    print_message "$BLUE" "========================================"
    print_message "$BLUE" "Test Results Summary"
    print_message "$BLUE" "========================================"

    if [ $dangerous_test_result -eq 0 ]; then
        print_message "$GREEN" "✓ Dangerous Repository Test: PASSED"
    else
        print_message "$RED" "✗ Dangerous Repository Test: FAILED"
    fi

    if [ $stealth_test_result -eq 0 ]; then
        print_message "$GREEN" "✓ Stealth Repository Test: PASSED"
    else
        print_message "$RED" "✗ Stealth Repository Test: FAILED"
    fi

    if [ $safe_test_result -eq 0 ]; then
        print_message "$GREEN" "✓ Safe Repository Test: PASSED"
    else
        print_message "$RED" "✗ Safe Repository Test: FAILED"
    fi

    # Return overall result
    if [ $dangerous_test_result -eq 0 ] && [ $stealth_test_result -eq 0 ] && [ $safe_test_result -eq 0 ]; then
        print_message "$GREEN" "All tests passed! git-safe-clone is working as expected."
        return 0
    else
        print_message "$RED" "Some tests failed. git-safe-clone may not be working correctly."
        return 1
    fi
}

# Run the main function
main
exit $?
