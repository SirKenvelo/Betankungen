---
id: BL-0021
title: Tankbeleg-Foto-Links als Referenz speichern
status: proposed
priority: P3
type: feature
tags: [receipts, photos, links, storage]
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
- Validierungs- und Ausgabeleitplanken fuer Linkfelder.
- Klare Backup-/Privacy-Abgrenzung fuer externe Dateipfade gemaess `POL-003`.

Out of Scope:
- Binaere Bildspeicherung in SQLite.
- Upload-/Sync-/OCR-Pipeline fuer Belege.
- Automatisches Datei-Management ausserhalb der bestehenden DB-Workflows.

# Risks
- Tote Links bei verschobenen/geloeschten Dateien.
- Pfadangaben koennen sensible lokale Strukturen offenlegen.
- Plattformunterschiede bei absoluten/relativen Pfaden.

# Output
Ein klarer, optionaler Referenzrahmen fuer Belegfotos, der den Core nicht mit
Datei-Binaries belastet und mit bestehenden Privacy-/Backup-Leitplanken
kompatibel bleibt.

# Derived Tasks
- Werden bei Aktivierung als `TSK-xxxx` angelegt.
