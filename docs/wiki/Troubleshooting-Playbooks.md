# Troubleshooting Playbooks
**Stand:** 2026-03-15

## Verify fails locally

1. Check toolchain availability (`fpc`, `sqlite3`, `make`).
2. Run `make build` and `make verify` again from project root.
3. Re-run affected suites directly (for example `tests/smoke/smoke_cli.sh --modules`).

Reference docs:
- [Tests overview](../../tests/README.md)
- [Release preflight 0.9.0](../RELEASE_0_9_0_PREFLIGHT.md)

## Module integration path fails

1. Validate module metadata:
   `betankungen-maintenance --module-info --json --pretty`
2. Run module smoke path:
   `tests/smoke/smoke_modules.sh`
3. Check module contract docs and regression expectations.

Reference docs:
- [Modules architecture](../MODULES_ARCHITECTURE.md)
- [Export contract](../EXPORT_CONTRACT.md)

## Need safe rollback snapshot before risky changes

1. Create a snapshot:
   `scripts/backup_snapshot.sh --note "manual pre-change snapshot"`
2. Confirm snapshot index under `.backup/index.json`.

Reference docs:
- [Restore guide](../RESTORE.md)
- [Backup policy](../policies/POL-003-backup-retention-restore-privacy.md)
