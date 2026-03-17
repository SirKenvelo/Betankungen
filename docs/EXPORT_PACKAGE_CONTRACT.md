# Export Package Contract
**Stand:** 2026-03-17
**Status:** draft v1 (Gate 3 / BL-0014)

## Ziel

Dieser Contract beschreibt ein manifestbasiertes Paketformat fuer spaetere
Import-/Export-Bundles. Fokus ist eine reproduzierbare Dry-Run-Validierung,
nicht die produktive Import-Pipeline.

## Paketlayout (v1)

```text
<bundle-root>/
  manifest.json
  payload/
    *.csv | *.json
```

## Manifest v1 (Pflichtfelder)

Top-Level:
- `manifest_version` (int, aktuell `1`)
- `package_kind` (string, z. B. `betankungen_export_bundle_v1`)
- `created_at` (UTC ISO-8601, Format `YYYY-MM-DDTHH:MM:SSZ`)
- `source` (object)
- `payload_files` (array, mindestens ein Eintrag)

`source`:
- `app_version` (string)
- `export_contract_version` (int >= 1)
- `db_schema_version` (int >= 1)
- `generated_by` (string)

`payload_files[]`:
- `path` (relativer Pfad unterhalb des Bundle-Roots)
- `sha256` (64-stellig, lowercase hex)
- `bytes` (int >= 0)
- optional: `media_type` (string)

## Integritaetsregeln (v1)

- Jede in `payload_files[]` gelistete Datei muss physisch existieren.
- `path` darf den Bundle-Kontext nicht verlassen (kein absoluter Pfad,
  kein `..`-Traversal).
- `bytes` muss exakt der Dateigroesse entsprechen.
- `sha256` muss exakt dem SHA-256-Hash der Datei entsprechen.
- Doppelte Payload-Pfade sind ungueltig.

## Dry-Run-Fixtures

Pfad: `tests/regression/fixtures/package_manifest_v1/`

- `valid_minimal`: gueltiges Minimalbundle (CSV + JSON Payload)
- `invalid_missing_source_app_version`: Pflichtfeld in `source` fehlt
- `invalid_checksum_mismatch`: Hash entspricht nicht dem Payload-Inhalt
- `invalid_payload_path_traversal`: ungueltiger relativer Pfad (`..`)

## Lokaler Check-Runner

Der Runner validiert alle v1-Fixtures reproduzierbar:

```bash
tests/regression/run_package_manifest_fixture_check.sh
```

Optional via `make`:

```bash
make package-manifest-check
```

## Nicht-Ziele in 1.1.0

- Keine produktive Import-Runtime.
- Keine Migrationsautomatik fuer historische Export-Staende.
- Kein Release-Blocker im Standard-`make verify` ohne explizite Aktivierung.
