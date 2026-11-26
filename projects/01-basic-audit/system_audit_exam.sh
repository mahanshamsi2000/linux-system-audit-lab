#!/usr/bin/env bash
# system_audit_exam.sh - Basic system audit (bootcamp assignment)

set -u

AUDIT_DIR="$HOME/exam_results/audit"
RUN_DIR="$(pwd)"   # captured before any cd: the directory the script was run from

setup_directory() {
    mkdir -p "$AUDIT_DIR"
    : > "$AUDIT_DIR/notes.txt"
    printf '%s\n' "$RUN_DIR" > "$AUDIT_DIR/cwd.txt"
}

main() {
    setup_directory
}

main "$@"
