# Verbindlicher Fahrplan bis Version 1.5.0
**Stand:** 2026-05-06
**Status:** aktiv (`APP_VERSION=1.5.0-dev`; Gate 1 abgeschlossen, Gate 2 noch nicht gestartet)

## Ausgangslage

- `1.4.0` wurde am 2026-04-15 final freigegeben und bleibt aktuell der
  stabile technische Stand.
- Der Dev-Start fuer `1.5.0-dev` wurde am 2026-05-06 bewusst als separater
  Gate-1-Aktivierungsblock ausgefuehrt; die aktuelle Produktwahrheit ist
  jetzt `APP_VERSION=1.5.0-dev`.
- `BL-0033` ist geliefert und stellt den ersten read-only Referenzscreen fuer
  `Betankungen --list fuelups --detail` bereit.
- `ADR-0015` ist `accepted` und legt die CLI-first-TUI-Evolutionsstrategie
  verbindlich fest.
- Fuer die naechste Produktlinie wird `BL-0034` als eigenstaendiger Kandidat
  priorisiert; `BL-0032` bleibt ausdruecklich ausserhalb dieser Linie.

## Verbindliche Leitplanken

- `BL-0034` wird als fokussierte Produktlinie mit genau einem ersten echten
  Realflow vorbereitet: `--add fuelups`.
- Der Formularpfad ist ein TTY-only-Komfortpfad; er wird nur bei echtem
  interaktivem Terminal aktiv.
- Der bisherige Prompt-Flow bleibt dauerhaft als Fallback fuer Non-TTY,
  Pipes, CI, Tests und Notfallpfade erhalten.
- Im ersten Schritt ist nur extrahierte Minimal-Generik erlaubt:
  Input-Events, Feldzustand, Navigation und eine kleine Render-Huelle.
- Domainvalidierung und Produktregeln bleiben in der bestehenden
  Fachschicht; eine zweite Fachlogik im Formular-Layer ist unzulaessig.
- Qualitaet vor Breite: primaerer Produktwert ist bessere Fehlersicherheit
  und Klarheit; Geschwindigkeit ist nachgelagert.
- `BL-0032` bleibt ausdruecklich ausserhalb dieser Linie.
- Ein voll generisches TUI-Framework, Form-DSL oder Theming-Block gehoert
  nicht in den initialen `1.5.0`-Scope.

## Scope fuer 1.5.0

### In Scope

1. Einen ersten echten Formular-Flow fuer `--add fuelups` liefern, der den
   bestehenden interaktiven Prompt-Flow im TTY-Kontext ergonomisch ergaenzt,
   aber nicht ersetzt.
2. Eine kleine, wiederverwendbare Input-/Form-Basis einziehen, die genau fuer
   diesen ersten Flow ausreicht: Tastenereignisse, Feldzustand, Navigation,
   Cancel-/Confirm-Verhalten und eine enge Render-Huelle.
3. Den bestehenden CLI-/Fachvertrag erhalten:
   - CLI bleibt steuernde Einstiegsschicht
   - Non-TTY-/Automationspfade bleiben funktionsfaehig
   - Persistenz- und Domainvalidierung bleiben in `u_fuelups` bzw. der
     vorhandenen Fachschicht
4. Verify- und Regressionsevidenz fuer den neuen Komfortpfad aufbauen, ohne
   die bestehenden read-only Contracts oder Fuelup-Policies zu verwischen.

### Nicht Teil von 1.5.0

- `BL-0032` und jede Receipt-Storage- oder XDG-Ordner-Strategie
- weitere echte Formular-Flows fuer `stations`, `cars` oder Edit-Pfade
- Big-Bang-Umbau aller Add-/Edit-Flows
- generische Widget-Bibliothek ohne direkten Mehrwert fuer den ersten
  Fuelup-Flow
- neue Persistenzsemantik, neue Fachregeln oder Verlagerung von
  Domainvalidierung in Widgets/Rendercode
- neue GUI-/Maus-/Fenstersysteme ausserhalb des Terminalkontexts

## Gate-Plan bis 1.5.0

### Gate 1: Dev-Start / Scope-Klaerung

- `BL-0034` als enge Produktlinie mit genau einem ersten Realflow
  festziehen.
- TTY-only-Aktivierung, Fallback-Regel und Nicht-Ziele explizit verankern.

Exit-Kriterium:
- `--add fuelups` ist als erster Ziel-Flow verbindlich benannt.
- `1.5.0-dev` ist per separatem Aktivierungsblock gestartet, ohne bereits
  Gate-2-Arbeit oder BL-0034-Umsetzung mitzuziehen.

Status:
- abgeschlossen am 2026-05-06.

### Gate 2: Scope-Freeze / Form-Contract

- Interaktionsvertrag fuer den ersten Formular-Slice festziehen.
- Bedienmodell fuer Navigation, Cancel, Confirm und Persistenzgrenzen
  definieren.
- Erlaubte Minimal-Generik gegen Framework-Overreach abgrenzen.

Exit-Kriterium:
- Bedienvertrag und Fallback-Verhalten sind klar.
- UI-Layer bleibt nachweislich fachlogikfrei.

Status:
- geplant.

### Gate 3: minimale Input-/Form-Basis

- Kleinen TTY-Input-/Form-Unterbau fuer den ersten Flow vorbereiten.
- Nur die Basis einfuehren, die der erste Fuelup-Flow tatsaechlich braucht.

Exit-Kriterium:
- Eine enge technische Basis fuer Eingabe-Events, Feldzustand, Navigation und
  Rendering existiert, ohne bereits zu einem Voll-Framework zu wachsen.

Status:
- geplant.

### Gate 4: Integration in `--add fuelups`

- Den ersten echten Formular-Flow produktseitig nutzbar machen.
- Non-TTY-/Fallback-Pfade explizit intakt halten.
- Bestehende Domainvalidierung und Persistenz weiterverwenden.

Exit-Kriterium:
- `--add fuelups` bietet im TTY-Kontext den Formularpfad.
- Fuelup-Policies, Car-Context- und Receipt-Link-Contracts bleiben gruenden
  Tests zufolge intakt.

Status:
- geplant.

### Gate 5: Abschluss / Verify / Handoff

- Die Linie mit einem sauberen Verify-/Handoff-Zuschnitt abschliessen.
- Sichtbar dokumentieren, was geliefert wurde und was bewusst ausserhalb
  blieb.

Exit-Kriterium:
- Verify- und Testlage ist gruen.
- Es ist klar, ob die Linie mit einem einzigen Flow endet oder ob ein
  Folgeblock spaeter bewusst neu entschieden werden muss.

Status:
- geplant.

## Verifikation und Evidenz

- Smoke-Tests fuer den ersten Formular-Flow
- Smoke-Tests fuer den Non-TTY-/Fallback-Pfad
- Regressionen fuer bestehende Fuelup-Contracts
- Regressionen fuer Car-Context-, Receipt-Link- und Confirm-Pfade
- Domain-/Policy-Tests fuer unveraenderte Fachregeln
- CLI-/TUI-Flow-Tests fuer Navigation, Abbruch, Confirm und kein stilles
  Persistieren

## Formale Startregel

Diese Roadmap ist jetzt die verbindliche aktive Produktlinie fuer den
`1.5.0-dev`-Zyklus.

Der Dev-Start ist bewusst eng ausgefuehrt worden:

- `APP_VERSION` wurde in einem separaten Aktivierungsblock auf
  `1.5.0-dev` angehoben.
- Gate 1 ist damit abgeschlossen.
- Gate 2 ist noch nicht gestartet.
- `BL-0034` bleibt weiterhin unimplementiert; diese Roadmap aktiviert nur die
  Entwicklungsbasis und den verbindlichen Scope-Rahmen.

Weiterhin gilt:

- `1.4.0` bleibt die letzte stabile Release-Version.
- `BL-0032` bleibt ausserhalb dieser Linie.
- Es wurden keine neuen Tasks geschnitten und keine Folge-Gates
  vorweggenommen.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_5_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
