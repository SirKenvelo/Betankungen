# ADR-0009: Runtime-Config-Profile im Core abgelehnt
**Stand:** 2026-03-15
**Status:** rejected
**Datum:** 2026-03-15

## Kontext

Es wurde vorgeschlagen, Profile wie `default`, `work` und `demo` mit schnellem
Profilwechsel direkt in die Runtime des Core aufzunehmen.

## Entscheidung

Der Vorschlag wird fuer den Core abgelehnt.

Betankungen fuehrt keine impliziten Runtime-Profile ein.

## Begruendung

- Das Projekt priorisiert explizites CLI-Verhalten statt impliziter Zustaende.
- Profile wuerden versteckte Kontextwechsel einfuehren und die Bedienung weniger
  transparent machen.
- Bestehende Mechanismen decken den Bedarf bereits explizit ab:
  `--db`, `--db-set`, `--demo`, `--seed` sowie klar getrennte DB-Pfade.
- Fuer den aktuellen Scope-Freeze (0.9.0-Linie) waere die Einfuehrung zusaetzlich
  ein unnoetiges Risiko ohne unmittelbaren Mehrwert.

## Konsequenzen

- Kein Profil-Umschalter in der Core-CLI.
- Arbeitskontexte bleiben explizit und scriptbar ueber vorhandene Flags/Umgebung.
- Falls spaeter Bedarf entsteht, werden Wrapper/Launcher ausserhalb der
  Core-Runtime bevorzugt.

## Referenzen

- `docs/CONSTRAINTS.md`
- `docs/STATUS.md`
- `docs/RELEASE_0_9_0_PREFLIGHT.md`
