#!/usr/bin/env bash
set -euo pipefail

# sprint_docs_lint.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-12
# Lint fuer Sprint-/Doku-Qualitaet: [SxCy/z], Hash-Referenzen, Stand-Datum, TBD-Marker.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT_DIR" <<'PY'
from __future__ import annotations

import datetime as dt
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
errors: list[str] = []

STAND_RE = re.compile(r"^\*\*Stand:\*\*\s*([0-9]{4}-[0-9]{2}-[0-9]{2})\s*$", re.MULTILINE)
TBD_RE = re.compile(r"\bTBD\b", re.IGNORECASE)
SPRINT_TAG_RE = re.compile(r"\[S\d+C\d+/\d+\]")
HEX7_RE = re.compile(r"^[0-9a-f]{7}$")


def add_err(path: Path, line_no: int, msg: str) -> None:
    rel = path.relative_to(root)
    errors.append(f"{rel}:{line_no}: {msg}")


def all_markdown_files() -> list[Path]:
    files: list[Path] = []
    for base in (root / "docs", root / "tests"):
        if base.exists():
            files.extend(sorted(base.rglob("*.md")))
    return files


def validate_stand_and_tbd(path: Path) -> None:
    text = path.read_text(encoding="utf-8")

    m = STAND_RE.search(text)
    if not m:
        add_err(path, 1, "fehlendes oder ungueltiges Stand-Datum (**Stand:** YYYY-MM-DD).")
    else:
        date_raw = m.group(1)
        try:
            dt.date.fromisoformat(date_raw)
        except ValueError:
            line_no = text[: m.start(1)].count("\n") + 1
            add_err(path, line_no, f"ungueltiges Stand-Datum: {date_raw}")

    for idx, line in enumerate(text.splitlines(), start=1):
        # Inline-Code (`...`) wird bei der TBD-Pruefung ignoriert, damit
        # Dokumentationsbeispiele wie "keine `TBD`-Marker" nicht false-positive failen.
        line_wo_inline_code = re.sub(r"`[^`]*`", "", line)
        if TBD_RE.search(line_wo_inline_code):
            add_err(path, idx, "TBD-Marker gefunden.")


def validate_changelog(path: Path) -> None:
    lines = path.read_text(encoding="utf-8").splitlines()

    in_unreleased = False
    in_changed = False
    in_sprint_refs = False

    for idx, line in enumerate(lines, start=1):
        if line.startswith("## [Unreleased]"):
            in_unreleased = True
            in_changed = False
            in_sprint_refs = False
            continue

        if in_unreleased and line.startswith("## "):
            in_unreleased = False
            in_changed = False
            in_sprint_refs = False

        if not in_unreleased:
            continue

        if line.startswith("### Changed"):
            in_changed = True
            in_sprint_refs = False
            continue

        if line.startswith("### Sprint / Commit References"):
            in_sprint_refs = True
            in_changed = False
            continue

        if line.startswith("### ") and not line.startswith("### Changed") and not line.startswith("### Sprint / Commit References"):
            in_changed = False
            in_sprint_refs = False

        if in_changed and line.startswith("- "):
            if not re.match(r"^- \[(General|S\d+C\d+/\d+)\] ", line):
                add_err(path, idx, "Eintrag unter [Unreleased] -> Changed muss mit [General] oder [SxCy/z] starten.")

        if in_sprint_refs and line.startswith("- "):
            m = re.search(r"Basis-Commit:\s*`([^`]+)`", line)
            if not m:
                add_err(path, idx, "Sprint-Referenz ohne Basis-Commit-Hash.")
            else:
                hash_raw = m.group(1)
                if not HEX7_RE.match(hash_raw):
                    add_err(path, idx, f"Basis-Commit-Hash muss 7-stellig hex sein, gefunden: {hash_raw}")


def validate_sprints(path: Path) -> None:
    lines = path.read_text(encoding="utf-8").splitlines()

    heading_idx: list[int] = []
    for idx, line in enumerate(lines, start=1):
        if re.match(r"^\d+\.\s+", line):
            if not re.match(r"^\d+\.\s+S\d+C\d+/\d+\s*$", line):
                add_err(path, idx, "Commit-Folge-Eintrag muss Format '<n>. SxCy/z' haben.")
            heading_idx.append(idx)

        if "Git-Commit:" in line:
            m = re.search(r"Git-Commit:\s*`([^`]+)`", line)
            if not m:
                add_err(path, idx, "Git-Commit-Zeile ohne Hash in Backticks.")
            else:
                hash_raw = m.group(1)
                if not HEX7_RE.match(hash_raw):
                    add_err(path, idx, f"Git-Commit-Hash muss 7-stellig hex sein, gefunden: {hash_raw}")

    # Jede Commit-Ueberschrift muss bis zum naechsten Block eine Git-Commit-Zeile haben.
    for i, start_idx in enumerate(heading_idx):
        end_idx = heading_idx[i + 1] - 1 if i + 1 < len(heading_idx) else len(lines)
        window = lines[start_idx:end_idx]
        if not any("Git-Commit:" in ln for ln in window):
            add_err(path, start_idx, "Commit-Folge-Eintrag ohne zugehoerige Git-Commit-Zeile.")


def main() -> int:
    md_files = all_markdown_files()

    for file_path in md_files:
        validate_stand_and_tbd(file_path)

    changelog = root / "docs" / "CHANGELOG.md"
    sprints = root / "docs" / "SPRINTS.md"

    if changelog.exists():
        validate_changelog(changelog)
    else:
        errors.append("docs/CHANGELOG.md fehlt.")

    if sprints.exists():
        validate_sprints(sprints)
    else:
        errors.append("docs/SPRINTS.md fehlt.")

    if errors:
        for err in errors:
            print(f"[FAIL] {err}")
        print(f"[FAIL] Sprint-/Doku-Lint fehlgeschlagen ({len(errors)} Problem(e)).")
        return 1

    print("[OK] Sprint-/Doku-Lint erfolgreich.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
PY
