---
id: BL-0032
title: Receipt Storage Strategy and Optional Managed Archive
status: proposed
priority: P3
type: research
tags: [receipts, storage, xdg, files, 'lane:exploratory']
created: 2026-04-02
updated: 2026-04-02
related:
  - BL-0021
  - BL-0031
  - ISS-0009
---
**Stand:** 2026-04-02

# Goal
Eine spaetere Hybrid-Strategie fuer Tankbelege vorbereiten, bei der
benutzerverwaltete externe Ordner weiterhin erlaubt bleiben, aber optional ein
app-verwalteter Receipt-Ordner unter XDG-Regeln als Komfortmodus eingefuehrt
werden kann.

# Motivation
Die aktuelle Link-Strategie aus `BL-0021` ist bewusst leichtgewichtig und
funktioniert gut, solange Nutzer ihre Belegbilder selbst verwalten. Aus realer
Nutzung entsteht jedoch eine zweite Frage: Ob Betankungen spaeter einen
standardisierten, eigenen Belegpfad anbieten sollte, damit Drag-and-Drop,
Normalisierung und Auffindbarkeit noch bequemer werden.

Ein harter XDG-Zwang waere dafuer zu streng. Nutzer koennen ihre Belege heute
bereits sinnvoll in eigenen Foto-, Scan- oder Sync-Ordnern pflegen. Deshalb
soll ein spaeterer Receipt-Storage-Block nur eine Hybrid-Loesung evaluieren:
externe Pfade bleiben erlaubt, ein verwalteter XDG-Ordner waere nur ein
optionaler Komfortmodus.

# Scope
In Scope:
- Hybrid-Strategie fuer Receipt-Speicherung beschreiben: externe Ordner plus
  optionaler app-verwalteter XDG-Ordner.
- Festlegen, ob und wie eine spaetere Kopier-/Import-Funktion fuer lokale
  Belegbilder aussehen duerfte.
- Backup-/Privacy-/Pfad-Offenlegungsfragen fuer einen verwalteten Receipt-
  Ordner explizit machen.
- Kriterien formulieren, wann ein app-verwalteter Receipt-Ordner echten
  Nutzwert bringt und wann nicht.

Out of Scope:
- Sofortige Runtime-Implementierung eines Receipt-Imports oder Datei-Kopierens.
- Verpflichtende XDG-Belegablage fuer alle Nutzer.
- OCR-, Upload-, Cloud- oder Sync-Pipeline fuer Belege.
- Neue Bildspeicherung in SQLite oder im Core-Datenmodell.

# Risks
- Ein spaeterer Receipt-Manager erzeugt doppelte Dateien und unklare
  Verantwortlichkeit fuer Backup und Aufraeumen.
- Ein app-verwalteter Ordner wird stillschweigend zur versteckten Pflicht,
  obwohl der offene Pfad-/URI-Contract erhalten bleiben soll.
- Privacy-/Path-Leak-Fragen werden durch neue Kopier-/Importpfade komplexer.

# Output
Ein klar abgegrenzter Folge-Backlog fuer eine spaetere Entscheidung, ob
Betankungen neben benutzerverwalteten Belegordnern zusaetzlich einen
optionalen, app-verwalteten XDG-Receipt-Pfad anbieten sollte.
