# ADR-0015: CLI-first TUI Evolution Strategy
**Stand:** 2026-04-07
**Status:** accepted
**Datum:** 2026-04-07

## Kontext

Betankungen ist bewusst als terminalbasierte CLI-Anwendung gewachsen und hat
die fachliche Prioritaet bislang klar auf Robustheit, Nachvollziehbarkeit und
saubere Domaenenlogik gelegt. Das war fachlich richtig und bleibt die Basis.

Mit zunehmender realer Nutzung zeigt sich jedoch ein zweiter Bedarf: Die
aktuelle Ausgabe- und Interaktionsschicht wirkt funktional, aber visuell und
ergonomisch noch zu roh. Listen, Detailansichten und interaktive Add-Flows
erfuellen ihren Zweck, fuehlen sich jedoch eher wie ein technisch korrektes
Werkzeug als wie eine bewusst gestaltete Terminal-Anwendung an.

Gleichzeitig soll Betankungen weder in eine GUI noch in ein schwergewichtiges
TUI-Framework kippen. Die bestehende CLI-Philosophie bleibt bewusst erhalten:

- Flags und Kommandos steuern den Use Case
- non-interactive und automatisierte Workflows bleiben erstklassig
- die UI-Schicht darf keine zweite Fachlogik einfuehren

Offen war damit nicht die Produktidentitaet, sondern die Einfuehrungsstrategie
fuer eine spaetere Komfort- und Darstellungsschicht.

## Entscheidung

Betankungen bleibt **CLI-first** und fuehrt eine optionale TUI-Schicht nur
schrittweise als Komfort- und Darstellungsebene ein.

Die bevorzugte Architektur ist eine **eigene duenne UI-Schicht** auf Basis der
vorhandenen Terminal-/ANSI-Moeglichkeiten, nicht ein schwergewichtiges
Fremdframework.

Der angestrebte Aufbau ist:

- `u_terminal` fuer Low-Level-Terminalzugriff
- `u_painter` fuer wiederverwendbare Zeichen- und Layoutoperationen
- `u_views_*` fuer konkrete read-only Screens und Listen-/Detailansichten
- spaeter optional `u_input`, `u_widgets` und `u_form` fuer interaktive
  Komfortformulare

Die Einfuehrung erfolgt iterativ:

1. zuerst ein einzelner Referenzscreen fuer read-only Views
2. danach, bei bewaehrter Render-/View-Basis, ein spaeteres Form-System

## Leitplanken

- Bestehende klassische CLI-Pfade bleiben vollstaendig erhalten und
  funktionsfaehig.
- Interaktive TUI-Komfortpfade sind optional und duerfen non-interactive
  sowie automatisierte Workflows weder verdraengen noch funktional
  benachteiligen.
- Die Einfuehrung erfolgt iterativ; ein Big-Bang-Refactor aller Views oder
  Screens ist ausgeschlossen.
- Als erster Migrationskandidat wird genau ein Referenzscreen definiert,
  z. B. `fuelups --list --detail`.
- Ein generisches Form-System wird erst eingefuehrt, nachdem sich
  View-/Painter-Basis und Render-Konventionen im Referenzscreen bewaehrt
  haben.
- Neue UI-Bausteine muessen so gestaltet werden, dass bestehende
  Domaenenlogik, Persistenzregeln und CLI-Semantik unveraendert bleiben.
- Die UI ist Huelle und Interaktionsschicht, nicht der Ort fuer neue
  Fachlogik.

## Nicht-Ziele

- keine Abkehr von der CLI-first-Architektur
- keine verpflichtende TUI fuer alle Nutzer
- kein Big-Bang-Umbau aller Listen-, Detail- und Add-/Edit-Flows
- keine Einfuehrung eines schwergewichtigen Frameworks als neue
  Produktgrundlage
- keine Vermischung von Darstellungslogik mit Domain- oder
  Persistenzentscheidungen

## Konsequenzen

- Ein spaeterer UI-Refresh wird als eigener, klar begrenzter Entwicklungsstrang
  behandelbar.
- Read-only-Views und Formularsysteme werden bewusst getrennt priorisiert.
- Ein frueher Referenzscreen kann Render-Konventionen, Layout und
  Teststrategie validieren, bevor weitere Screens folgen.
- Non-interactive CLI- und Automationspfade bleiben die verbindliche
  Steuerlogik auch dann, wenn spaeter Komfortformulare hinzukommen.
- Themen wie Theming, High-Contrast oder alternative Farbpaletten bleiben
  moeglich, aber nachgeordnet gegenueber Struktur, Lesbarkeit und
  Wartbarkeit.

## Referenzen

- `docs/backlog/BL-0033-tui-presentation-and-view-layer-refresh/item.md`
- `docs/backlog/BL-0034-tui-form-system-for-interactive-flows/item.md`
- `docs/STATUS.md`
- `docs/README.md`
- `units/u_fmt.pas`
