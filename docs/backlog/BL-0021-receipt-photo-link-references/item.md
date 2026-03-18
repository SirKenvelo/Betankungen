---
id: BL-0021
title: Tankbeleg-Foto-Links als Referenz speichern
status: done
priority: P2
type: feature
tags: [receipts, photos, links, storage, 'lane:release-blocking']
created: 2026-03-18
updated: 2026-03-18
related:
  - POL-003
  - BL-0020
---
**Stand:** 2026-03-18

# Goal
Fotos von Tankbelegen als externe Referenz speichern, ohne Bilddateien in der
Anwendungsdatenbank abzulegen.

# Motivation
Im Betriebsalltag liegen Belegbilder oft bereits in einem separaten Ordner
(z. B. Raspberry Pi / NAS / Docker-Volume). Das Programm soll nur den Link
pflegen, damit Nachweise auffindbar bleiben und die Core-DB schlank bleibt.

# Scope
In Scope:
- Datenfeld-Strategie fuer externe Belegreferenzen (Pfad/URI-Link).
- Append-only-kompatibler Write-Path fuer neue Fuelups mit optionalem Link.
- Validierungs- und Ausgabeleitplanken fuer Linkfelder.
- Klare Backup-/Privacy-Abgrenzung fuer externe Dateipfade gemaess `POL-003`.
- Contract-sichtbare JSON-Ausgabe fuer gesetzte/fehlende Linkfelder.

Out of Scope:
- Binaere Bildspeicherung in SQLite.
- Upload-/Sync-/OCR-Pipeline fuer Belege.
- Automatisches Datei-Management ausserhalb der bestehenden DB-Workflows.

# Risks
- Tote Links bei verschobenen/geloeschten Dateien.
- Pfadangaben koennen sensible lokale Strukturen offenlegen.
- Plattformunterschiede bei absoluten/relativen Pfaden.

# Output
Release-blocking Referenzrahmen fuer `1.2.0`, der externe Beleglinks im Core
abbildet, ohne Datei-Binaries in SQLite abzulegen, und dabei mit
Privacy-/Backup-Leitplanken kompatibel bleibt.

# Derived Tasks
- `TSK-0010` - Receipt-Link-Contract und Privacy-Guardrails definieren. (done)
- `TSK-0011` - Receipt-Link-Write-Path und Output-/Contract-Nachweise liefern. (done)
