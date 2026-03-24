# Polling-Runtime-Basis fuer 1.3.0
**Stand:** 2026-03-24

## Ziel

Dieses Dokument beschreibt die gelieferte Runtime-Basis fuer `BL-0018` auf dem
Stand `1.3.0`: separater Datenpfad, minimaler Polling-Runner,
Historienpersistenz und Regressionsevidenz.

## Gelieferter Runtime-Baustein

- Script: `scripts/fuel_price_polling_run.sh`
- Zweck: fuehrt genau einen Polling-/Ingest-Lauf fuer einen externen
  Preis-Snapshot aus.
- Eingangsmodus in `1.3.0`: lokaler JSON-Snapshot via `--snapshot-file`
- Unterstuetzter Provider in der Minimalbasis: `tankerkoenig`
- Scheduling bleibt bewusst ausserhalb des Core-CLI-Prozesses
  (z. B. `cron`, `systemd timer`, externer Supervisor)

## Datenpfad und Artefakte

Default-Wurzel:
- `~/.local/share/Betankungen/fuel_price_history/`

Artefakte pro erfolgreichem Lauf:
- `raw/<provider>/<yyyy>/<mm>/<dd>/<provider>_<timestamp>_<scope>.json`
- `db/fuel_price_history.db`
- `state/<provider>_last_run.json`

Die produktive Core-Datenbank `betankungen.db` bleibt unberuehrt.

## Minimaler Ablauf

Beispiel:

```bash
scripts/fuel_price_polling_run.sh \
  --provider tankerkoenig \
  --snapshot-file snapshot.json \
  --scope nearby-stations \
  --fetched-at 2026-03-24T18:30:00Z
```

Der Lauf:

1. validiert Provider, Snapshot-Datei, Scope und UTC-Zeitstempel
2. schreibt den Raw-Snapshot in den getrennten Historienpfad
3. persistiert Snapshot-Metadaten in `provider_snapshots`
4. normalisiert Preiszeilen in `station_price_history`
5. aktualisiert den letzten erfolgreichen Stand in `provider_state`
6. schreibt eine lesbare Zustandsdatei unter `state/`

## Regression und Verify

- Regression-Runner: `tests/regression/run_fuel_price_history_check.sh`
- Make-Target: `make fuel-price-history-check`
- Verify-Gate: `make verify` fuehrt den Check verbindlich mit aus

Abgedeckte Nachweise:

- Erfolgsfall mit validem `tankerkoenig`-Fixture
- Guardrails fuer fehlende Pflichtargumente
- Dry-Run ohne Dateischreibzugriffe
- Duplikat-Schutz fuer identische Laeufe
- Fehlerpfad bei invalidem Snapshot ohne stehenbleibenden Partial-Write

## Audit-Relevanz

- Rohdaten bleiben als unveraenderter Snapshot nachvollziehbar.
- Persistenz und State liegen getrennt vom produktiven Core-Datenpfad.
- Fehlerhafte Laeufe hinterlassen keine stillen Teilimporte.
- Die Regression liefert einen reproduzierbaren Delta-/Risiko-Nachweis fuer
  Trennung, Persistenz und Guardrails.
