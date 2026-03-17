# package_manifest_v1 fixtures
**Stand:** 2026-03-17

Reproduzierbare Dry-Run-Fixtures fuer den Manifest-v1-Contract aus
`docs/EXPORT_PACKAGE_CONTRACT.md`.

## Faelle

- `valid_minimal/`
  - gueltiges Minimalbundle mit `manifest.json` und zwei Payload-Dateien.
- `invalid_missing_source_app_version/`
  - Manifest ohne Pflichtfeld `source.app_version`.
- `invalid_checksum_mismatch/`
  - Manifest mit absichtlich falschem SHA-256-Wert.
- `invalid_payload_path_traversal/`
  - Manifest mit ungueltigem Payload-Pfad (`..`-Traversal).

## Ausfuehrung

```bash
tests/regression/run_package_manifest_fixture_check.sh
```
