#!/usr/bin/env python3
"""ground_audit.py — find inference markers that must never reach the manuscript or the claims registry.

RESEARCH_FRAMEWORK S21 (Tak 2026-10-12): a statement nobody can source is said with ``[推測]``;
a source that is needed but not on disk is marked ``🔍要根拠`` and goes through ``/ground``.
Both markers live in lab records (SUITS.md, memos, IDEAS_BACKLOG.md). In ``paper/*.tex`` and
``CLAIMS.md`` they are findings: the text has been written on inference.

Usage:
  python3 scripts/ground_audit.py FILE [FILE ...] [--strict] [--markers M1,M2,...]
Exit 0 always, 1 with --strict when any marker is found.
"""
import argparse
import re
import sys
from pathlib import Path

DEFAULT_MARKERS = ["[推測]", "🔍要根拠", "[GROUND?]", "[INFERRED]"]


def scan(path: Path, markers):
    hits = []
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError as e:  # pragma: no cover
        return [(0, "", f"unreadable: {e}")]
    for n, line in enumerate(text.splitlines(), 1):
        for m in markers:
            if m in line:
                ctx = line.strip()
                if len(ctx) > 100:
                    i = ctx.find(m)
                    ctx = ("…" if i > 40 else "") + ctx[max(0, i - 40): i + 60] + "…"
                hits.append((n, m, ctx))
    return hits


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="+")
    ap.add_argument("--strict", action="store_true", help="exit 1 when any marker is found")
    ap.add_argument("--markers", default=",".join(DEFAULT_MARKERS),
                    help="comma-separated markers (default: %(default)s)")
    args = ap.parse_args(argv)
    markers = [m for m in args.markers.split(",") if m]
    # Windows consoles default to cp932, which cannot print the markers themselves
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):  # pragma: no cover
        pass
    total = 0
    for f in args.files:
        p = Path(f)
        if not p.is_file():
            continue
        for n, m, ctx in scan(p, markers):
            total += 1
            print(f"{p.as_posix()}:{n}: {m}: {ctx}")
    if total:
        print(f"ground_audit: {total} inference marker(s) in manuscript/claims files → /ground before the text goes further")
    else:
        print("ground_audit: 0 markers")
    return 1 if (total and args.strict) else 0


if __name__ == "__main__":
    sys.exit(main())
