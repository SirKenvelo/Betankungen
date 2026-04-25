#!/usr/bin/env bash
set -euo pipefail

# projtrack_lint.sh
# CREATED: 2026-03-13
# UPDATED: 2026-04-25
# Lint fuer Tracker-Dateien unter docs/issues + docs/backlog gemaess POL-001
# und fuer enge Steuerungsdoku-Grenzen.
# Dieser Linter prueft bewusst nicht PR-/Merge-/Tag-Artefakte.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT_DIR" <<'PY'
from __future__ import annotations

import datetime as dt
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

root = Path(sys.argv[1])

errors: list[str] = []
warnings: list[str] = []

RE_DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
RE_PRIORITY = re.compile(r"^P[0-4]$")
RE_ID = re.compile(r"^[A-Z]+-\d{3,4}$")

RE_ADR = re.compile(r"^ADR-\d{4}$")
RE_BL = re.compile(r"^BL-(\d{4}|\d{3})$")
RE_ISS = re.compile(r"^ISS-(\d{4}|\d{3})$")
RE_TSK = re.compile(r"^TSK-(\d{4}|\d{3})$")
RE_POL = re.compile(r"^POL-\d{3}$")

STATUS_ISSUE = {"open", "investigating", "blocked", "resolved", "closed", "wontfix", "duplicate"}
STATUS_BACKLOG = {"idea", "proposed", "approved", "in_progress", "blocked", "done", "dropped"}
STATUS_TASK = {"todo", "doing", "blocked", "done", "cancelled"}

TYPE_ISSUE = {"bug", "incident", "problem"}
TYPE_BACKLOG = {"feature", "improvement", "refactor", "debt", "research"}
TYPE_TASK = {"task"}
RE_FORBIDDEN_TRACKER_HEADING = re.compile(r"^## (Note|Notes)\b")
RE_FORBIDDEN_SPRINT_STEERING_HEADING = re.compile(r"^## (General-Stream|Traceability-Backfill)\b")


@dataclass
class TrackerDoc:
    path: Path
    kind: str
    meta: dict[str, Any]


def rel(path: Path) -> str:
    return str(path.relative_to(root))


def add_err(path: Path, msg: str) -> None:
    errors.append(f"{rel(path)}: {msg}")


def add_warn(path: Path, msg: str) -> None:
    warnings.append(f"{rel(path)}: {msg}")


def parse_frontmatter(path: Path) -> dict[str, Any]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    if len(lines) < 3 or lines[0].strip() != "---":
        raise ValueError("fehlender Frontmatter-Block ('---').")

    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end = i
            break
    if end is None:
        raise ValueError("nicht abgeschlossener Frontmatter-Block.")

    meta: dict[str, Any] = {}
    i = 1
    while i < end:
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        if line.startswith("  - "):
            raise ValueError(f"ungueltige Listenzeile ohne Schluessel in Zeile {i + 1}.")
        if ":" not in line:
            raise ValueError(f"ungueltige Frontmatter-Zeile {i + 1}: '{line}'")

        key, raw_value = line.split(":", 1)
        key = key.strip()
        value = raw_value.strip()

        if not key:
            raise ValueError(f"leerer Schluessel in Zeile {i + 1}.")

        if value.startswith("[") and value.endswith("]"):
            inner = value[1:-1].strip()
            if inner == "":
                meta[key] = []
            else:
                meta[key] = [p.strip() for p in inner.split(",") if p.strip()]
        elif value == "":
            arr: list[str] = []
            j = i + 1
            while j < end and lines[j].startswith("  - "):
                arr.append(lines[j][4:].strip())
                j += 1
            if arr:
                meta[key] = arr
                i = j - 1
            else:
                meta[key] = ""
        else:
            meta[key] = value
        i += 1

    return meta


def collect_tracker_docs() -> list[TrackerDoc]:
    docs: list[TrackerDoc] = []
    patterns = [
        ("issue", "docs/issues/**/issue.md"),
        ("backlog", "docs/backlog/**/item.md"),
        ("task", "docs/backlog/**/tasks/TSK-*.md"),
        ("task", "docs/tasks/**/TSK-*.md"),
    ]

    for kind, pattern in patterns:
        for path in sorted(root.glob(pattern)):
            if not path.is_file():
                continue
            try:
                meta = parse_frontmatter(path)
            except ValueError as exc:
                add_err(path, str(exc))
                continue
            docs.append(TrackerDoc(path=path, kind=kind, meta=meta))

    return docs


def add_external_id_index() -> set[str]:
    known: set[str] = set()
    external_patterns = [
        ("ADR", "docs/ADR/ADR-*.md"),
        ("ADR", "docs/adr/ADR-*.md"),
        ("BL", "docs/BACKLOG/BL-*.md"),
        ("POL", "docs/policies/POL-*.md"),
    ]
    for prefix, pattern in external_patterns:
        for path in sorted(root.glob(pattern)):
            stem = path.stem
            m = re.match(rf"^({prefix}-\d{{3,4}})", stem)
            if m:
                known.add(m.group(1))
    return known


def validate_meta(doc: TrackerDoc, known_ids: set[str]) -> None:
    meta = doc.meta
    path = doc.path

    required = {"id", "title", "status", "priority", "type", "tags", "created", "updated"}
    for key in required:
        if key not in meta:
            add_err(path, f"fehlendes Pflichtfeld '{key}'.")

    if "id" not in meta:
        return

    id_raw = str(meta["id"]).strip()
    if not RE_ID.match(id_raw):
        add_err(path, f"ungueltige id '{id_raw}'.")
        return

    if id_raw.startswith("BL-") and re.match(r"^BL-\d{3}$", id_raw):
        add_warn(path, f"Legacy-ID verwendet ({id_raw}); neu 4-stellig bevorzugt.")
    if id_raw.startswith("ISS-") and re.match(r"^ISS-\d{3}$", id_raw):
        add_warn(path, f"Legacy-ID verwendet ({id_raw}); neu 4-stellig bevorzugt.")
    if id_raw.startswith("TSK-") and re.match(r"^TSK-\d{3}$", id_raw):
        add_warn(path, f"Legacy-ID verwendet ({id_raw}); neu 4-stellig bevorzugt.")

    if doc.kind == "issue":
        if not RE_ISS.match(id_raw):
            add_err(path, f"issue.md erwartet ISS-ID, gefunden: {id_raw}")
    elif doc.kind == "backlog":
        if not RE_BL.match(id_raw):
            add_err(path, f"item.md erwartet BL-ID, gefunden: {id_raw}")
    elif doc.kind == "task":
        if not RE_TSK.match(id_raw):
            add_err(path, f"Task-Datei erwartet TSK-ID, gefunden: {id_raw}")

    status = str(meta.get("status", "")).strip()
    if doc.kind == "issue" and status not in STATUS_ISSUE:
        add_err(path, f"ungueltiger status fuer issue: '{status}'")
    if doc.kind == "backlog" and status not in STATUS_BACKLOG:
        add_err(path, f"ungueltiger status fuer backlog: '{status}'")
    if doc.kind == "task" and status not in STATUS_TASK:
        add_err(path, f"ungueltiger status fuer task: '{status}'")

    type_raw = str(meta.get("type", "")).strip()
    if doc.kind == "issue" and type_raw not in TYPE_ISSUE:
        add_err(path, f"ungueltiger type fuer issue: '{type_raw}'")
    if doc.kind == "backlog" and type_raw not in TYPE_BACKLOG:
        add_err(path, f"ungueltiger type fuer backlog: '{type_raw}'")
    if doc.kind == "task" and type_raw not in TYPE_TASK:
        add_err(path, f"ungueltiger type fuer task: '{type_raw}'")

    priority = str(meta.get("priority", "")).strip()
    if not RE_PRIORITY.match(priority):
        add_err(path, f"ungueltige priority: '{priority}'")

    for date_key in ("created", "updated"):
        raw = str(meta.get(date_key, "")).strip()
        if not RE_DATE.match(raw):
            add_err(path, f"{date_key} muss YYYY-MM-DD sein, gefunden: '{raw}'")
            continue
        try:
            dt.date.fromisoformat(raw)
        except ValueError:
            add_err(path, f"{date_key} ist kein gueltiges Datum: '{raw}'")

    tags = meta.get("tags")
    if not isinstance(tags, list):
        add_err(path, "tags muss Liste sein (z. B. [cli, validation]).")

    related = meta.get("related", [])
    if related == "":
        related = []
    if not isinstance(related, list):
        add_err(path, "related muss Liste sein.")
        related = []

    for ref in related:
        ref_raw = str(ref).strip()
        if not RE_ID.match(ref_raw):
            add_err(path, f"ungueltige related-ID: '{ref_raw}'")
            continue
        if ref_raw not in known_ids:
            add_err(path, f"defekte Referenz in related: '{ref_raw}' nicht gefunden.")

    if doc.kind == "task":
        parent = str(meta.get("parent", "")).strip()
        if not parent:
            add_err(path, "task erfordert parent: BL-xxxx")
        elif not RE_BL.match(parent):
            add_err(path, f"ungueltiges parent fuer task: '{parent}'")
        elif parent not in known_ids:
            add_err(path, f"parent '{parent}' nicht gefunden.")

def scan_code_refs(known_ids: set[str]) -> None:
    patt = re.compile(r"\b(TODO|FIXME|NOTE|REF)\(([A-Z]+-\d{3,4})\):")
    code_roots = [root / "src", root / "units", root / "tests", root / "scripts"]
    exts = {".pas", ".pp", ".lpr", ".sh", ".py"}

    for base in code_roots:
        if not base.exists():
            continue
        for path in sorted(base.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in exts:
                continue
            try:
                text = path.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            for i, line in enumerate(text.splitlines(), start=1):
                for m in patt.finditer(line):
                    kind, ref_id = m.group(1), m.group(2)
                    if kind == "FIXME" and not RE_ISS.match(ref_id):
                        errors.append(f"{rel(path)}:{i}: FIXME muss ISS referenzieren, gefunden {ref_id}")
                        continue
                    if kind == "NOTE" and not RE_ADR.match(ref_id):
                        errors.append(f"{rel(path)}:{i}: NOTE muss ADR referenzieren, gefunden {ref_id}")
                        continue
                    if kind == "REF" and not RE_POL.match(ref_id):
                        errors.append(f"{rel(path)}:{i}: REF muss POL referenzieren, gefunden {ref_id}")
                        continue
                    if kind == "TODO" and not (RE_BL.match(ref_id) or RE_ISS.match(ref_id)):
                        errors.append(f"{rel(path)}:{i}: TODO muss BL/ISS referenzieren, gefunden {ref_id}")
                        continue
                    if ref_id not in known_ids:
                        errors.append(f"{rel(path)}:{i}: defekte Code-Referenz {kind}({ref_id})")


def scan_tracker_heading_style(docs: list[TrackerDoc]) -> None:
    for doc in docs:
        try:
            lines = doc.path.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            continue

        for i, line in enumerate(lines, start=1):
            if RE_FORBIDDEN_TRACKER_HEADING.match(line):
                errors.append(
                    f"{rel(doc.path)}:{i}: ungueltige Tracker-Ueberschrift '{line.strip()}'; "
                    "verwende in Tracker-Dateien die kanonische Form '# Notes'."
                )


def scan_steering_doc_boundaries() -> None:
    sprints = root / "docs" / "SPRINTS.md"
    general_streams = root / "docs" / "GENERAL_STREAMS.md"

    if not sprints.exists():
        errors.append("docs/SPRINTS.md fehlt.")
        return

    try:
        lines = sprints.read_text(encoding="utf-8", errors="replace").splitlines()
    except OSError as exc:
        errors.append(f"docs/SPRINTS.md: konnte Datei nicht lesen: {exc}")
        return

    for i, line in enumerate(lines, start=1):
        if RE_FORBIDDEN_SPRINT_STEERING_HEADING.match(line):
            errors.append(
                f"docs/SPRINTS.md:{i}: nicht-sprintgebundener Steuerungsblock "
                f"'{line.strip()}' gehoert nach docs/GENERAL_STREAMS.md."
            )

    if not general_streams.exists():
        errors.append(
            "docs/GENERAL_STREAMS.md fehlt; nicht-sprintgebundene Steuerungsbloecke "
            "brauchen eine eigene Zielablage."
        )


def main() -> int:
    docs = collect_tracker_docs()

    if not docs:
        print("[WARN] Keine Tracker-Dateien unter docs/issues oder docs/backlog gefunden.")
        return 0

    known_ids_external = add_external_id_index()
    tracker_ids: dict[str, Path] = {}

    for doc in docs:
        id_raw = str(doc.meta.get("id", "")).strip()
        if not RE_ID.match(id_raw):
            continue
        if id_raw in tracker_ids:
            add_err(doc.path, f"doppelte ID '{id_raw}' (bereits in {rel(tracker_ids[id_raw])})")
        else:
            tracker_ids[id_raw] = doc.path

    for tid, tpath in tracker_ids.items():
        if tid in known_ids_external:
            add_warn(tpath, f"ID '{tid}' existiert bereits im Legacy-Bestand.")

    known_ids_all = set(known_ids_external) | set(tracker_ids.keys())

    for doc in docs:
        validate_meta(doc, known_ids_all)

    scan_tracker_heading_style(docs)
    scan_steering_doc_boundaries()
    scan_code_refs(known_ids_all)

    for w in warnings:
        print(f"[WARN] {w}")
    for e in errors:
        print(f"[FAIL] {e}")

    if errors:
        print(f"[FAIL] projtrack-lint fehlgeschlagen ({len(errors)} Problem(e)).")
        return 1

    if warnings:
        print(f"[OK] projtrack-lint erfolgreich mit {len(warnings)} Warnung(en).")
    else:
        print("[OK] projtrack-lint erfolgreich.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
PY
