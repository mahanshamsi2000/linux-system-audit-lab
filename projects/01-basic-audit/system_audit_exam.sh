#!/usr/bin/env bash
# system_audit_exam.sh - Basic system audit (bootcamp assignment)

set -u

AUDIT_DIR="$HOME/exam_results/audit"
RUN_DIR="$(pwd)"   # captured before any cd: the directory the script was run from

# write_heading FILE TITLE: create FILE containing a single comment heading
write_heading() {
    printf '# %s\n' "$2" > "$1"
}

setup_directory() {
    mkdir -p "$AUDIT_DIR"
    : > "$AUDIT_DIR/notes.txt"
    write_heading "$AUDIT_DIR/cwd.txt" "Directory the script was run from"
    printf '%s\n' "$RUN_DIR" >> "$AUDIT_DIR/cwd.txt"
}

collect_users() {
    write_heading "$AUDIT_DIR/users.txt" "All usernames from /etc/passwd"
    awk -F: '{print $1}' /etc/passwd >> "$AUDIT_DIR/users.txt"

    write_heading "$AUDIT_DIR/bash_users.txt" "Users whose login shell is /bin/bash"
    awk -F: '$7 == "/bin/bash" {print $1}' /etc/passwd >> "$AUDIT_DIR/bash_users.txt"

    write_heading "$AUDIT_DIR/shell_preview.txt" "First 5 lines of /etc/passwd with /bin/bash replaced by /usr/bin/zsh (preview only)"
    sed 's#/bin/bash#/usr/bin/zsh#g' /etc/passwd | head -n 5 >> "$AUDIT_DIR/shell_preview.txt"
}

main() {
    setup_directory
    collect_users
}

main "$@"
