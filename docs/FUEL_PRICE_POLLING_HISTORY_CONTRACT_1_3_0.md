# Polling- und Historien-Contract fuer 1.3.0
**Stand:** 2026-03-24

## Ziel

Dieses Dokument definiert fuer `1.3.0` den verbindlichen Minimal-Contract fuer
externes Tankstellenpreis-Polling, Rohdatenablage, Historienpersistenz und die
strikte Trennung zur produktiven Core-Datenbank.

## Verbindliche Grundsaetze

- Die technische Primaerquelle fuer `1.3.0` ist `Tankerkoenig`; degradierter
  Fallback bleibt `Benzinpreis-Aktuell.de` gemaess
  `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md`.
- Polling-/Historien-Daten sind keine Erweiterung der produktiven
  `betankungen.db`, sondern laufen in einem getrennten Datenpfad.
- Contract-Evolution folgt `POL-002`: additive Erweiterungen sind bevorzugt;
  Breaking-Changes an Dateipfaden, JSON-Feldern oder Persistenzsemantik sind
  fuer `1.3.0` nicht vorgesehen.
- Backup-/Restore-/Privacy-Regeln folgen `POL-003`.
- `1.3.0` liefert die belastbare Basis fuer spaetere Auswertungen, aber noch
  keinen finalen Analytics-Vollausbau.

## Datenpfad-Trennung

### Core-Datenbank

- Produktive Tankdaten bleiben in der bisherigen Core-Datenbank
  `~/.local/share/Betankungen/betankungen.db`.
- Die Core-Datenbank enthaelt fuer `1.3.0` keine Tabellen fuer externes
  Preis-Polling und keine Rohsnapshot-Payloads.

### Polling-/Historienbasis

- Neuer Wurzelpfad fuer externe Preis-Historie:
  `~/.local/share/Betankungen/fuel_price_history/`
- Unterstruktur fuer `1.3.0`:
  - `raw/<provider>/<yyyy>/<mm>/<dd>/`
  - `db/fuel_price_history.db`
  - `state/`
- Der Wurzelpfad darf getrennt gesichert, rotiert oder geloescht werden, ohne
  die produktive Core-Datenbank zu beschaedigen.

## Rohdatenformat

- Jeder Polling-Lauf schreibt pro erfolgreichem Provider-Abruf genau einen
  unveraenderten Raw-Snapshot als JSON-Datei.
- Dateinamensschema:
  `<provider>_<utc-timestamp>_<scope>.json`
- Beispiel:
  `tankerkoenig_2026-03-24T18-30-00Z_nearby-stations.json`
- Das Rohformat bleibt provider-nah; keine verlustbehaftete Vor-Normalisierung
  vor dem Speichern.

Pflicht-Metadaten je Snapshot:

- `provider`
- `fetched_at_utc`
- `request_scope`
- `source_url` oder logisch gleichwertige Request-Referenz
- `payload`

## Historien-Persistenz

- Die normalisierte Historienbasis liegt in
  `~/.local/share/Betankungen/fuel_price_history/db/fuel_price_history.db`.
- Minimal erforderliche Tabellen fuer `1.3.0`:
  - `provider_snapshots`
  - `station_price_history`
  - `provider_state`

### Tabelle `provider_snapshots`

Zweck:
- Lauf-Metadaten und Referenz auf den Raw-Snapshot speichern.

Minimalfelder:
- `id`
- `provider`
- `fetched_at_utc`
- `request_scope`
- `raw_path`
- `http_status` oder provider-semantisch gleichwertiger Abrufstatus
- `station_count`
- `ingest_status`

### Tabelle `station_price_history`

Zweck:
- Normalisierte Preiszeitreihe pro Station und Kraftstofftyp aufbauen.

Minimalfelder:
- `id`
- `provider_snapshot_id`
- `provider`
- `provider_station_id`
- `recorded_at_utc`
- `fuel_type`
- `price_eur_x1000`
- `currency_code`
- `station_name`
- `station_brand`
- `street`
- `house_no`
- `postal_code`
- `city`
- `lat`
- `lon`
- `is_open`

### Tabelle `provider_state`

Zweck:
- Letzten erfolgreichen Lauf und einfache Polling-Steuerdaten festhalten.

Minimalfelder:
- `provider`
- `last_success_at_utc`
- `last_attempt_at_utc`
- `last_error_code`
- `last_error_summary`
- `backoff_until_utc`

## Integrationsgrenzen zum Core

- Kein direkter Fremdschluessel von `station_price_history` auf Core-Tabellen
  der produktiven Tankdatenbank in `1.3.0`.
- Ein spaeteres Matching zwischen Preis-Historie und eigenen `fuelups` bleibt
  fachlich erlaubt, erfolgt aber nur ueber explizite Join-/Mapping-Logik in
  einem spaeteren Feature-Schritt.
- Stationen aus externen Preisquellen werden fuer `1.3.0` nicht automatisch in
  produktive `stations` importiert.
- Backup, Restore und Troubleshooting fuer `fuel_price_history.db` bleiben als
  separater Betriebsfall dokumentierbar.

## Polling-Leitplanken fuer 1.3.0

- Zielintervall: `15` Minuten.
- Kein Anspruch auf harte Realtime-Latenz unterhalb des Intervalls.
- Jitter ist erlaubt und empfohlen, um Burst-Last zu reduzieren.
- Bei Provider-Fehlern gilt Backoff statt aggressiver Retry-Schleifen.
- Der letzte erfolgreiche Stand bleibt lesbar, auch wenn ein Folgelauf
  fehlschlaegt.
- Polling darf die Core-CLI nicht blockieren; es ist konzeptionell ein
  separater Datenstrom.

## Retention, Privacy und Restore

- Es werden nur oeffentlich verfuegbare Tankstellenpreis- und Stationsdaten
  verarbeitet; keine personenbezogenen Endnutzerdaten sind Teil des
  Polling-Contracts.
- Raw-Snapshots duerfen fuer Audit-/Fehleranalyse laenger vorgehalten werden
  als normalisierte Historienreihen, muessen aber getrennt rotierbar bleiben.
- Die genaue Retention-Zahl ist fuer `1.3.0` implementierungsseitig noch offen;
  zwingend ist nur die dokumentierte Trennbarkeit zwischen `raw/` und
  `fuel_price_history.db`.
- Restore erfolgt pfadgetrennt von der Core-Datenbank.

## Fehler- und Statusmodell

- Ein fehlgeschlagener Provider-Abruf darf keine bereits persistierte
  Preis-Historie beschaedigen.
- Fehler werden mindestens auf Snapshot-/Provider-State-Ebene dokumentiert.
- Teilweise leere oder unvollstaendige Provider-Antworten muessen als
  technischer Zustand nachvollziehbar bleiben und duerfen nicht still als
  gueltige Vollmessung maskiert werden.

## Audit- und Nachweisfit

- Fuer `1.3.0` ist kein pauschales Vollaudit dieses Datenstroms vorgesehen.
- Das Dokument bildet aber die Mindestbasis fuer Delta-/Risiko-Audits zu
  Datenpfad, Trennung, Rohdatenhaltung und Betriebsgrenzen.
- Implementierungs- und Regressionsevidenz fuer diesen Contract liegt auf
  Runtime-Stand in `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md` sowie in
  `tests/regression/run_fuel_price_history_check.sh` vor.

## Ergebnis fuer Gate 3

- `TSK-0020` ist mit diesem Dokument fachlich erfuellt.
- Der technische Folgepfad aus `TSK-0021` ist auf Runtime-Basis geliefert:
  separater Runner, Persistenzpfad und Regressionsevidenz sind vorhanden.
