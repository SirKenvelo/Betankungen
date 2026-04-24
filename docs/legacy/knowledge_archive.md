# knowledge_archive Bridge
**Stand:** 2026-04-24

## Status

`knowledge_archive/` ist im Produkt-Repo keine aktive Snippet-Ablage mehr.
Der historische Bestand wurde am 2026-04-24 in die externe Audit-Ablage
uebernommen:

`/home/christof/Projekte/Audit/Betankungen/evidence/legacy/knowledge_archive/`

Im Produkt-Repo bleibt nur diese Bridge-Schicht:
- `docs/legacy/knowledge_archive.md` als kanonischer Vertrag.
- `knowledge_archive/README.md` als kurzer Uebergangshinweis fuer alte Pfade.

## Vertrag

- Neue Archiv-Snippets werden repo-seitig nicht mehr erzeugt.
- Die Git-Historie bleibt der primaere Rueckgriff fuer fruehere
  Implementationsstaende.
- Die externe Audit-Ablage ist eine lesbare Legacy-Kopie, keine aktive
  Runtime-, Build- oder Testquelle.
- Historische Changelog-, Sprint- und Audit-Verweise auf den frueheren
  Repo-Pfad werden nicht rueckwirkend umgeschrieben.
- Smoke- und Strukturchecks pruefen den Bridge-Vertrag, nicht mehr die
  Existenz getrackter Snippet-Dateien im Produkt-Repo.

## Externalisiert

Externalisiert wurden:
- die fruehere Inventar-README aus `knowledge_archive/README.md`
- alle 14 historischen Pascal-Snippets aus `knowledge_archive/*.pas`

Im Produkt-Repo verbleibt vorerst:
- `knowledge_archive/README.md` als knappe Pfadbruecke fuer Nutzer, Skripte
  oder historische Links, die noch den alten Ordner oeffnen.

## Spaeterer Aufraeumschritt

Wenn keine lokalen oder externen Arbeitsablaeufe mehr den alten Ordnerpfad
erwarten, kann `knowledge_archive/README.md` in einem separaten Pflegeblock
entfernt werden. Der kanonische Hinweis bleibt dann diese Datei unter
`docs/legacy/`.
