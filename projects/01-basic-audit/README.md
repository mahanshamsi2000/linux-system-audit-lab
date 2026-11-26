# 01 - Basic System Audit

Bootcamp assignment: `system_audit_exam.sh` collects basic information about
users, system, configuration/log files and permissions, then archives the results.

## Usage

```bash
./system_audit_exam.sh
```

Output directory: `~/exam_results/audit`. Archive: `~/exam_results/audit.zip`.

## Behavior

1. Creates the audit directory, an empty `notes.txt`, and `cwd.txt` (the directory the script was run from).
2. Extracts usernames, `/bin/bash` users, and a preview of `/etc/passwd` with `/bin/bash` replaced by `/usr/bin/zsh` (the real file is never modified).
3. Records kernel name/version, architecture, and the first 3 / last 2 lines of `/etc/group`.
4. Lists `.conf` files under `/etc` and the 10 largest files under `/var/log`.
5. Backs up `/etc/hosts` as `hosts.bak` (mode 600) and records `ls -l hosts.bak`.
6. Creates `audit.zip`, **then** removes all `.txt` files except `hosts_perm.txt` and `notes.txt`.

## Interpretation decisions

- The ZIP is created before cleanup so it contains all generated files.
- `notes.txt` is kept empty (no heading), as the assignment requires.
- Every other `.txt` file starts with a single `#` heading line.
- `top_logs.txt` contains size in bytes followed by the path.

## Known limitations

- Runs without `sudo`; unreadable directories (e.g. `/var/log/private`) are skipped, so results may be incomplete.
- Files with equal size are ordered arbitrarily in `top_logs.txt`.
- Paths containing spaces or newlines are not handled specially.
