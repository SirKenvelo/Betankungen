#!/usr/bin/env bash
set -euo pipefail

# lazarus_purity_check.sh
# CREATED: 2026-04-17
# UPDATED: 2026-04-24
# Fail-fast-Guardrail fuer den aktiven FPC-/CLI-Baum ohne Lazarus-/LCL-Drift.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT_DIR" <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

root = Path(sys.argv[1])

active_dirs = [
    root / "src",
    root / "units",
    root / "tests",
    root / "scripts",
    root / ".github" / "workflows",
]
active_files = [
    root / "Makefile",
    root / ".vscode" / "tasks.json",
]
excluded_content_paths = {
    root / "scripts" / "lazarus_purity_check.sh",
}

artifact_suffixes = {
    ".lpi": "Lazarus project file",
    ".lfm": "Lazarus form resource",
    ".lrs": "Lazarus resource include",
    ".lps": "Lazarus session file",
}

allow_marker = "purity-check: allow"

generic_patterns = [
    ("Lazarus build command", re.compile(r"\blazbuild\b", re.IGNORECASE)),
    ("Lazarus IDE launcher", re.compile(r"\bstartlazarus\b", re.IGNORECASE)),
    (
        "Forbidden Lazarus artifact reference",
        re.compile(r"\.(?:lpi|lfm|lrs|lps)\b", re.IGNORECASE),
    ),
]

pascal_patterns = [
    ("Forbidden Lazarus/LCL unit 'Forms'", re.compile(r"\bForms\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'Dialogs'", re.compile(r"\bDialogs\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'Controls'", re.compile(r"\bControls\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'Interfaces'", re.compile(r"\bInterfaces\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'LCLType'", re.compile(r"\bLCLType\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'LCLIntf'", re.compile(r"\bLCLIntf\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'LMessages'", re.compile(r"\bLMessages\b", re.IGNORECASE)),
    ("Forbidden Lazarus/LCL unit 'LResources'", re.compile(r"\bLResources\b", re.IGNORECASE)),
    (
        "Forbidden Lazarus/LCL unit 'DefaultTranslator'",
        re.compile(r"\bDefaultTranslator\b", re.IGNORECASE),
    ),
    ("Forbidden Lazarus/LCL unit 'LazUTF8'", re.compile(r"\bLazUTF8\b", re.IGNORECASE)),
    (
        "Forbidden Lazarus/LCL unit 'LazFileUtils'",
        re.compile(r"\bLazFileUtils\b", re.IGNORECASE),
    ),
    (
        "Forbidden Lazarus/LCL form resource directive",
        re.compile(r"\{\$\s*R\s+\*\.lfm\s*\}", re.IGNORECASE),
    ),
    (
        "Forbidden Lazarus/LCL resource include",
        re.compile(r"\{\$\s*I\s+\*\.lrs\s*\}", re.IGNORECASE),
    ),
    (
        "Forbidden Lazarus/LCL conditional",
        re.compile(r"\{\$\s*IFN?DEF\s+(?:LCL|LAZARUS)\s*\}", re.IGNORECASE),
    ),
    (
        "Forbidden GUI application bootstrap",
        re.compile(r"\bApplication\.(?:Initialize|CreateForm|Run)\b", re.IGNORECASE),
    ),
    ("Forbidden GUI helper 'ShowMessage'", re.compile(r"\bShowMessage\b", re.IGNORECASE)),
]

pascal_suffixes = {".pas", ".pp", ".lpr"}
violations: list[str] = []


def rel(path: Path) -> str:
    return str(path.relative_to(root))


def add_violation(path: Path, message: str) -> None:
    violations.append(f"{rel(path)}: {message}")


def iter_active_files() -> list[Path]:
    files: list[Path] = []
    for directory in active_dirs:
        if not directory.exists():
            continue
        files.extend(path for path in sorted(directory.rglob("*")) if path.is_file())
    files.extend(path for path in active_files if path.is_file())
    return sorted(set(files))


def scan_artifact_paths(paths: list[Path]) -> None:
    for path in paths:
        suffix = path.suffix.lower()
        if suffix in artifact_suffixes:
            add_violation(path, f"{artifact_suffixes[suffix]} detected in active tree.")


def scan_content(path: Path) -> None:
    if path in excluded_content_paths:
        return

    text = path.read_text(encoding="utf-8", errors="replace")
    patterns = list(generic_patterns)
    if path.suffix.lower() in pascal_suffixes:
        patterns.extend(pascal_patterns)

    for lineno, raw_line in enumerate(text.splitlines(), start=1):
        if allow_marker in raw_line:
            continue
        for label, pattern in patterns:
            if pattern.search(raw_line):
                snippet = raw_line.strip()
                if len(snippet) > 160:
                    snippet = snippet[:157] + "..."
                add_violation(path, f"line {lineno}: {label} -> {snippet}")


paths = iter_active_files()
scan_artifact_paths(paths)
for path in paths:
    scan_content(path)

if violations:
    print("[FAIL] Lazarus purity check failed for the active tree.", file=sys.stderr)
    print(
        "[INFO] Active scope: src/, units/, tests/, scripts/, Makefile, "
        ".github/workflows/, .vscode/tasks.json",
        file=sys.stderr,
    )
    print(
        "[INFO] Historical docs, tracker archives and the knowledge_archive "
        "bridge are "
        "deliberately excluded from this guardrail.",
        file=sys.stderr,
    )
    print("[INFO] Violations:", file=sys.stderr)
    for entry in violations:
        print(f"  - {entry}", file=sys.stderr)
    sys.exit(1)

print("[OK] Lazarus purity check passed for the active tree.")
print(
    "[INFO] Scope: src/, units/, tests/, scripts/, Makefile, "
    ".github/workflows/, .vscode/tasks.json"
)
print(
    "[INFO] Historical docs and archive areas stay outside this fail-fast guardrail."
)
PY
