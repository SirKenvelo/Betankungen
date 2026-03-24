# Evaluation von Tankstellenpreis-APIs fuer Betankungen 1.3.0
**Stand:** 2026-03-24
**Status:** abgeschlossen als Entscheidungsbasis fuer `BL-0017`

## Ziel

Fuer die `1.3.0`-Linie wird eine dauerhaft nutzbare, kostenlose und rechtlich
saubere Quelle fuer minutenaktuelle Tankstellenpreise in Deutschland benoetigt.
Der Zielbetrieb ist ein headless Setup auf Raspberry Pi, mit geplantem
15-Minuten-Polling und Fokus auf `E5`, `E10` und `Diesel`.

Diese Auswertung basiert auf der vom User bereitgestellten Research-
Ausarbeitung `Evaluation von Tankstellenpreis-APIs fuer Betankungen v1.3.0`
vom 2026-03-24 und ueberfuehrt deren Ergebnis in eine repo-taugliche,
entscheidbare Form fuer `BL-0017`, `TSK-0018` und `TSK-0019`.

## Go/No-Go-Kriterien

Die folgenden Kriterien sind fuer `1.3.0` verbindlich:

- Recht und Lizenz:
  explizite Nutzungsregeln, keine Grauzone, klare Attributionspflicht.
- Headless-Tauglichkeit:
  API-Key oder einfacher Token ist akzeptabel; Browser-/OAuth-Flow nicht.
- 24/7-Betrieb:
  dokumentiertes oder zumindest klar beobachtbares Limitierungsverhalten,
  saubere Backoff-Strategie und erwartbares Fehlerbild.
- Datenabdeckung:
  bundesweit nutzbar, MTS-K-nah, relevant fuer `E5`, `E10`, `Diesel`.
- Integrationsfit:
  kein Overkill fuer ein lokales, nicht-kommerzielles Polling-Projekt.

## Vergleichsmatrix

| Kandidat | Datenherkunft | Lizenz / ToS | Headless-Auth | Polling / Limits | Eignung fuer `1.3.0` |
| --- | --- | --- | --- | --- | --- |
| `Tankerkoenig` Creativecommons-API | MTS-K-nahe Preisdaten via REST/JSON | klarster kostenloser Rahmen: `CC BY 4.0` plus dokumentierte Zusatzregeln | API-Key, kein OAuth | dokumentierte Leitplanken, Jitter-Empfehlung, gebuendelte Preisabfrage, serverseitiges Rate-Limiting | `Go` als Primaerquelle |
| `Benzinpreis-Aktuell.de` API v2 | eigener VID auf Basis MTS-K | kostenlos, aber Lizenz-/Rate-Limit-Rahmen deutlich unklarer | keine Registrierung, einfacher URL-Zugriff | Update alle 5 Minuten genannt, aber kein transparentes Limit-/SLA-Modell | `Conditional Go` nur als Fallback |
| `TankenTanken` B2B-Schnittstellen | VID / MTS-K-basierte Daten | kein klarer kostenloser Open-Data-Rahmen; B2B-/Vertragsmodell | Kontakt/Testzugang statt Self-Service | keine oeffentlichen Free-Tier-Grenzen | `No-Go` fuer `1.3.0`, aber dokumentierter Eskalationspfad |
| direkter `MTS-K`-VID-Zugang | Primaerquelle | rechtlich sauber, aber mit hoher Compliance-Huerde | kein einfacher Self-Service | organisatorisch und technisch ueberdimensioniert | `No-Go` fuer `1.3.0` |

## Entscheidung

### Primaerquelle

Primaerquelle fuer Betankungen `1.3.0` ist die `Tankerkoenig`
Creativecommons-API.

Begruendung:

- die Lizenz- und Nutzungsregeln sind fuer einen kostenlosen Use Case am
  klarsten dokumentiert;
- das Auth-Modell ist headless-tauglich und passt zu einem Raspberry-Pi-
  Dienstbetrieb;
- das empfohlene Polling-Verhalten ist mit `15` Minuten konservativ und damit
  betrieblich gut vertretbar;
- der Preis-Endpoint erlaubt gebuendelte Abfragen mehrerer Stationen, was die
  Request-Last deutlich reduziert;
- die Quelle liefert den besten Fit zwischen rechtlicher Klarheit,
  Integrationsaufwand und Nutzbarkeit fuer `BL-0018`.

### Fallback

Technischer Fallback fuer degradierte Betriebsphasen ist
`Benzinpreis-Aktuell.de` API v2.

Der Fallback ist bewusst nur zweite Wahl, weil:

- der kostenlose Zugriff attraktiv ist;
- aber Lizenz, Limits und Betriebszusagen deutlich weniger transparent sind als
  bei `Tankerkoenig`;
- deshalb darf der Fallback nicht als primaere Dauerquelle fuer `1.3.0`
  modelliert werden.

### Eskalationspfad

Falls der kostenlose Betriebsrahmen spaeter nicht mehr ausreicht, ist
`TankenTanken` als kommerzieller B2B-Pfad dokumentiert. Das ist kein
Bestandteil von `1.3.0`, aber ein valider spaeterer Upgrade-Pfad.

## Ausschlussgruende

### Direkter `MTS-K`-Zugang

Als eigener VID ist dieser Weg fuer `1.3.0` ausgeschlossen, weil die
regulatorische und organisatorische Huerde nicht zum Projektziel passt.
Fuer ein lokales, headless, nicht-oeffentliches Polling-Projekt ist das
Overkill.

### `TankenTanken` als Primaerquelle

Fuer `1.3.0` ausgeschlossen, weil kein belastbarer kostenloser
Self-Service-Betrieb mit klaren Lizenz-/Limit-Angaben dokumentiert ist.

### `Benzinpreis-Aktuell.de` als Primaerquelle

Fuer `1.3.0` als Primaerquelle ausgeschlossen, weil ToS-/Lizenz- und
Rate-Limit-Transparenz schwaecher sind als bei `Tankerkoenig`. Der Dienst bleibt
nur als degradierter Fallback vertretbar.

## Betriebsgrenzen fuer `1.3.0`

Die folgenden Leitplanken sind fuer die spaetere Umsetzung verbindlich:

- Polling-Intervall:
  `15` Minuten als Standard, nicht aggressiver.
- Jitter:
  keine starren Polls auf vollen Viertelstunden; zufaellige Verteilung
  innerhalb eines kleinen Fensters.
- Request-Buendelung:
  Preise mehrerer Stationen pro Lauf zusammenfassen, statt Einzelabfragen zu
  vervielfachen.
- Backoff:
  bei `429`, `503`, providerseitigem Fehler oder ungueltigem `ok`-Status keine
  sofortige Wiederholungsschleife.
- Circuit-Breaker:
  nach mehreren Fehlern Provider temporaer aussetzen.
- Last Known Good:
  letzte valide Antwort lokal markierbar halten, statt bei Ausfall leere oder
  scheinbar frische Daten vorzutaeuschen.
- Key-Management:
  Provider-Keys nie im Repo, nie in Fixtures, nie in Logs.
- Datenpfad-Trennung:
  externe Preis-Historie bleibt ausserhalb der produktiven Tankdatenbank, bis
  `BL-0018` den finalen Contract liefert.

## Integrationsnotizen

- Die Auswertung entscheidet ueber den Provider, nicht ueber die finale
  Runtime-Sprache oder Bibliothek.
- Vorhandene Python-Wrapper sind fuer die Entscheidung zweitrangig, weil
  Betankungen selbst in Free Pascal umgesetzt wird und fuer `1.3.0` nur der
  HTTP-/Contract-Fit zaehlt.
- Fuer `BL-0018` ist eine kleine, explizite Provider-Abstraktion sinnvoll:
  primaerer Provider `Tankerkoenig`, optionaler Degradation-Pfad
  `Benzinpreis-Aktuell.de`, jeweils mit Statuskennzeichnung.

## Audit- und Nachweisbedarf

Fuer diese Research-/Dokumentschicht selbst ist gemaess externer Audit-
Strategie kein separates Vollaudit erforderlich.

Fuer die Folgeumsetzung `BL-0018` gilt:

- mindestens Delta-Audit fuer Provider-Integration und Contract-Pfade;
- Risiko-Audit, sobald Persistenzpfad, Daten-Trennung oder Recovery-Verhalten
  umgesetzt werden;
- spaetestens vor `Gate 4/5` ein Release-Audit gemaess
  `/home/christof/Projekte/Audit/Betankungen/strategy/AUDIT_STRATEGY_2026-03-24.md`.

Empfohlene Minimalchecks fuer die Folgeumsetzung:

- Contract-/Regression-Nachweise fuer Provider-Antworten und Fehlerfaelle;
- Power-/Scope-Pfade fuer Export-/JSON-/Historien-Verhalten;
- P5-orientierter Check fuer Persistenz, Recovery und Provider-Ausfallzustand.

## Ergebnis fuer den Tracker

- `TSK-0018`: abgeschlossen, weil Matrix, Betriebsgrenzen und
  Ausschlusskriterien dokumentiert sind.
- `TSK-0019`: abgeschlossen, weil Primaerquelle, Fallback und Audit-Bezug
  festgelegt sind.
- `BL-0017`: fachlich abgeschlossen; die Entscheidungsvorlage fuer `1.3.0`
  liegt vor.
- `BL-0018`: kann jetzt auf Basis dieser Entscheidung in den technischen
  Contract uebergehen.

## Quellenbasis

Die folgenden Quellenverweise stammen aus der bereitgestellten
Research-Ausarbeitung und bilden die fachliche Basis dieser Ueberfuehrung:

- `Tankerkoenig` Creativecommons-API
  `https://creativecommons.tankerkoenig.de/`
- `Tankerkoenig` Geschaeftsbedingungen / Onboarding
  `https://onboarding.tankerkoenig.de/`
- `Tankerkoenig` Blog / Last- und Betriebsverhalten
  `https://blog.tankerkoenig.de/`
- `Benzinpreis-Aktuell.de` API-Ankuendigung
  `https://www.benzinpreis-aktuell.de/artikel-104-neue-api-fuer-den-abruf-der-aktuellen-spritpreise-verfuegbar.html`
- `TankenTanken` / MTS-K-API
  `https://www.tankentanken.de/`
  `https://www.tankentanken.de/mts-k-api`
- regulatorischer Rahmen MTS-K / VID
  `https://dip21.bundestag.de/dip21/btd/17/123/1712390.pdf`
  `https://verwaltungsportal.hessen.de/leistung?leistung_id=B100019_102241578`
