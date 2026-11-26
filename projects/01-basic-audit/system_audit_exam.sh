#!/usr/bin/env bash
# system_audit_exam.sh - Basic system audit (bootcamp assignment)

set -u

AUDIT_DIR="$HOME/exam_results/audit"
ZIP_FILE="$HOME/exam_results/audit.zip"
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

collect_system() {
    write_heading "$AUDIT_DIR/sysinfo.txt" "Kernel name/version (uname -sr) and architecture (arch)"
    uname -sr >> "$AUDIT_DIR/sysinfo.txt"
    arch >> "$AUDIT_DIR/sysinfo.txt"

    write_heading "$AUDIT_DIR/group_summary.txt" "First 3 and last 2 lines of /etc/group"
    head -n 3 /etc/group >> "$AUDIT_DIR/group_summary.txt"
    tail -n 2 /etc/group >> "$AUDIT_DIR/group_summary.txt"
}

find_files() {
    write_heading "$AUDIT_DIR/conf_files.txt" ".conf files under /etc (unreadable directories skipped)"
    find /etc -type f -name '*.conf' 2>/dev/null | sort >> "$AUDIT_DIR/conf_files.txt"

    write_heading "$AUDIT_DIR/top_logs.txt" "10 largest files under /var/log (size in bytes, path)"
    find /var/log -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -n 10 >> "$AUDIT_DIR/top_logs.txt"
}

backup_hosts() {
    cp /etc/hosts "$AUDIT_DIR/hosts.bak"
    chmod 600 "$AUDIT_DIR/hosts.bak"
    write_heading "$AUDIT_DIR/hosts_perm.txt" "Output of: ls -l hosts.bak"
    (cd "$AUDIT_DIR" && ls -l hosts.bak) >> "$AUDIT_DIR/hosts_perm.txt"
}

# The ZIP is created BEFORE cleanup so it contains every generated file.
create_zip() {
    rm -f "$ZIP_FILE"
    (cd "$(dirname "$AUDIT_DIR")" && zip -r -q "$ZIP_FILE" "$(basename "$AUDIT_DIR")")
}

# Remove all .txt files in the audit directory except hosts_perm.txt and notes.txt.
cleanup() {
    if [ -z "$AUDIT_DIR" ] || [ ! -d "$AUDIT_DIR" ]; then
        echo "cleanup: invalid AUDIT_DIR, aborting" >&2
        return 1
    fi
    find "$AUDIT_DIR" -maxdepth 1 -type f -name '*.txt' \
        ! -name 'hosts_perm.txt' ! -name 'notes.txt' -delete
}

main() {
    setup_directory
    collect_users
    collect_system
    find_files
    backup_hosts
    create_zip
    cleanup
}

main "$@"
