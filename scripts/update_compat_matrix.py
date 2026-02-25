#!/usr/bin/env python3
"""Update the canonical compatibility matrix from observed verify-suite JSON evidence."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Sequence

REQUIRED_COLUMNS = [
    "Environment Profile",
    "Check Scope",
    "Status",
    "Caveat",
    "Command Set Reference",
    "Last Validated",
]
ALLOWED_STATUS = {"PASS", "SKIP", "FAIL"}
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


@dataclass
class MatrixTable:
    lines: List[str]
    header_idx: int
    separator_idx: int
    row_start: int
    row_end: int
    rows: List[List[str]]


def fail(message: str) -> "None":
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Update .planning/compatibility/v1.1-matrix.md with observed wrapper evidence"
    )
    parser.add_argument(
        "--matrix",
        default=".planning/compatibility/v1.1-matrix.md",
        help="Path to compatibility matrix markdown file",
    )
    parser.add_argument("--evidence", required=True, help="Path to verify-suite JSON evidence file")
    parser.add_argument("--env-profile", required=True, help="Matrix row Environment Profile")
    parser.add_argument("--check-scope", required=True, help="Matrix row Check Scope")
    parser.add_argument("--caveat", required=True, help="Matrix row caveat text")
    parser.add_argument("--command-ref", required=True, help="Matrix row command reference text")
    parser.add_argument("--date", required=True, help="Last validated date (YYYY-MM-DD)")
    parser.add_argument(
        "--status",
        choices=sorted(ALLOWED_STATUS),
        help="Optional explicit status override (validated against evidence)",
    )
    return parser.parse_args()


def load_evidence(path: Path) -> dict:
    if not path.is_file():
        fail(f"Evidence file does not exist: {path}")

    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"Evidence is not valid JSON: {exc}")

    if not isinstance(payload, dict):
        fail("Evidence payload must be a JSON object")

    if payload.get("format") != "json":
        fail("Evidence payload missing `format: json`")

    checks = payload.get("checks")
    summary = payload.get("summary")
    if not isinstance(checks, list) or not checks:
        fail("Evidence payload must include non-empty `checks` array")
    if not isinstance(summary, dict):
        fail("Evidence payload must include `summary` object")

    required_summary_keys = {"pass", "fail", "skip", "required_fail"}
    missing_summary = required_summary_keys - set(summary.keys())
    if missing_summary:
        fail(f"Evidence summary missing keys: {', '.join(sorted(missing_summary))}")

    if not isinstance(summary["required_fail"], bool):
        fail("Evidence summary `required_fail` must be boolean")

    for idx, check in enumerate(checks):
        if not isinstance(check, dict):
            fail(f"Evidence check at index {idx} must be object")
        status = check.get("status")
        if status not in ALLOWED_STATUS:
            fail(
                f"Evidence check at index {idx} has invalid status `{status}`; "
                f"allowed: {', '.join(sorted(ALLOWED_STATUS))}"
            )
        for key in ("id", "kind", "message"):
            value = check.get(key)
            if not isinstance(value, str) or not value.strip():
                fail(f"Evidence check at index {idx} missing non-empty string `{key}`")

    return payload


def derive_status(evidence: dict, explicit_status: str | None) -> str:
    required_fail = evidence["summary"]["required_fail"]
    derived = "FAIL" if required_fail else "PASS"
    if explicit_status is None:
        return derived

    if explicit_status == "PASS" and required_fail:
        fail("Explicit status PASS contradicts evidence summary required_fail=true")
    if explicit_status == "FAIL" and not required_fail:
        fail("Explicit status FAIL contradicts evidence summary required_fail=false")
    return explicit_status


def split_cells(line: str) -> List[str]:
    stripped = line.strip()
    if not (stripped.startswith("|") and stripped.endswith("|")):
        fail("Malformed table row: expected leading and trailing `|`")
    cells = [part.strip() for part in stripped.strip("|").split("|")]
    return cells


def load_matrix(path: Path) -> MatrixTable:
    if not path.is_file():
        fail(f"Matrix file does not exist: {path}")

    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines:
        fail("Matrix file is empty")

    header_idx = -1
    for idx, raw in enumerate(lines):
        stripped = raw.strip()
        if stripped.startswith("|") and stripped.endswith("|"):
            cells = split_cells(stripped)
            if cells == REQUIRED_COLUMNS:
                header_idx = idx
                break

    if header_idx == -1:
        fail(
            "Matrix table header not found with required columns: "
            + ", ".join(REQUIRED_COLUMNS)
        )

    separator_idx = header_idx + 1
    if separator_idx >= len(lines):
        fail("Matrix table separator row missing")

    separator = lines[separator_idx].strip()
    if not separator.startswith("|"):
        fail("Matrix table separator row is malformed")

    row_start = separator_idx + 1
    row_end = row_start
    rows: List[List[str]] = []
    for idx in range(row_start, len(lines)):
        stripped = lines[idx].strip()
        if not stripped.startswith("|"):
            break
        cells = split_cells(stripped)
        if len(cells) != len(REQUIRED_COLUMNS):
            fail(
                f"Matrix row has {len(cells)} cells, expected {len(REQUIRED_COLUMNS)} (line {idx + 1})"
            )
        if cells[2] not in ALLOWED_STATUS:
            fail(
                f"Matrix row has invalid status `{cells[2]}` at line {idx + 1}; "
                f"allowed: {', '.join(sorted(ALLOWED_STATUS))}"
            )
        rows.append(cells)
        row_end = idx + 1

    if not rows:
        fail("Matrix table has no data rows")

    return MatrixTable(
        lines=lines,
        header_idx=header_idx,
        separator_idx=separator_idx,
        row_start=row_start,
        row_end=row_end,
        rows=rows,
    )


def build_row(args: argparse.Namespace, status: str) -> List[str]:
    env_profile = args.env_profile.strip()
    check_scope = args.check_scope.strip()
    caveat = args.caveat.strip()
    command_ref = args.command_ref.strip()
    date_value = args.date.strip()

    if not env_profile:
        fail("`--env-profile` must be non-empty")
    if not check_scope:
        fail("`--check-scope` must be non-empty")
    if not caveat:
        fail("`--caveat` must be non-empty")
    if not command_ref:
        fail("`--command-ref` must be non-empty")
    if not DATE_RE.match(date_value):
        fail("`--date` must match YYYY-MM-DD")
    if status == "SKIP" and len(caveat) < 3:
        fail("SKIP status requires explicit caveat reason text")

    return [env_profile, check_scope, status, caveat, command_ref, date_value]


def update_rows(rows: Sequence[List[str]], new_row: List[str]) -> List[List[str]]:
    key = (new_row[0], new_row[1])
    updated_rows = list(rows)

    matching = [idx for idx, row in enumerate(updated_rows) if (row[0], row[1]) == key]
    if len(matching) > 1:
        fail(
            "Matrix contains duplicate row keys for "
            f"Environment Profile + Check Scope: {key[0]} | {key[1]}"
        )

    if matching:
        updated_rows[matching[0]] = new_row
    else:
        updated_rows.append(new_row)

    return updated_rows


def render_row(cells: Sequence[str]) -> str:
    return "| " + " | ".join(cells) + " |"


def write_matrix(path: Path, table: MatrixTable, rows: Sequence[Sequence[str]]) -> None:
    new_lines = list(table.lines)
    rendered = [render_row(row) for row in rows]
    new_lines[table.row_start : table.row_end] = rendered
    path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    evidence = load_evidence(Path(args.evidence))
    status = derive_status(evidence, args.status)
    table = load_matrix(Path(args.matrix))
    new_row = build_row(args, status)
    updated_rows = update_rows(table.rows, new_row)
    write_matrix(Path(args.matrix), table, updated_rows)

    action = "updated" if any((row[0], row[1]) == (new_row[0], new_row[1]) for row in table.rows) else "inserted"
    print(
        f"OK: {action} row for '{new_row[0]}' / '{new_row[1]}' with status {new_row[2]} in {args.matrix}",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
