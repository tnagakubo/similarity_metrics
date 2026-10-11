#!/usr/bin/env python3
"""
compare_results.py — compare a replication/reproduction CSV with the canonical results CSV (RESEARCH_FRAMEWORK S6).

Usage: python3 scripts/compare_results.py CANONICAL.csv CANDIDATE.csv --keys scenario,n[,method] [--tol 1e-6]
                                          [--rel-tol 0] [--columns a,b,c] [--out results/REPLICATION_YYYYMMDD.md]

Rows are matched on the key columns (string match after trimming, numeric strings compared as numbers).
For every numeric non-key column present in both files: n compared, max |diff|, max relative diff, and the
worst row. PASS when every column's max |diff| <= tol (or relative diff <= rel-tol when given). Rows present in
only one file are listed. Exit 1 on FAIL or missing rows. The markdown report (--out) is the gate artifact.
"""
import argparse
import csv
import sys
from datetime import date
from pathlib import Path


def read(path: Path):
    with path.open(newline="", encoding="utf-8") as fh:
        return list(csv.DictReader(fh))


def norm(v: str) -> str:
    v = (v or "").strip().strip('"')
    try:
        f = float(v)
        return repr(f) if "." in v or "e" in v.lower() else str(int(f))
    except ValueError:
        return v


def is_num(v: str) -> bool:
    try:
        float(v); return True
    except (TypeError, ValueError):
        return False


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("canonical"); ap.add_argument("candidate")
    ap.add_argument("--keys", required=True); ap.add_argument("--tol", type=float, default=1e-6)
    ap.add_argument("--rel-tol", type=float, default=0.0); ap.add_argument("--columns", default=None)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    keys = [k.strip() for k in a.keys.split(",")]
    A, B = read(Path(a.canonical)), read(Path(a.candidate))
    for k in keys:
        if A and k not in A[0]:
            print(f"compare_results: key '{k}' not in canonical"); return 2
        if B and k not in B[0]:
            print(f"compare_results: key '{k}' not in candidate"); return 2
    idxA = {tuple(norm(r[k]) for k in keys): r for r in A}
    idxB = {tuple(norm(r[k]) for k in keys): r for r in B}
    only_a, only_b = sorted(set(idxA) - set(idxB)), sorted(set(idxB) - set(idxA))
    common = sorted(set(idxA) & set(idxB))
    cols = [c.strip() for c in a.columns.split(",")] if a.columns else [c for c in (A[0].keys() if A else []) if c not in keys and B and c in B[0]]
    report, fail = [], False
    report.append(f"# Comparison — {Path(a.candidate).name} vs canonical {Path(a.canonical).name} ({date.today().isoformat()})\n")
    report.append(f"- keys: `{', '.join(keys)}` · rows canonical {len(A)}, candidate {len(B)}, matched {len(common)} · tol |diff| ≤ {a.tol}"
                  + (f", rel ≤ {a.rel_tol}" if a.rel_tol else "") + "\n")
    report.append("| column | n | max abs diff | max rel diff | worst row | verdict |\n|---|---|---|---|---|---|")
    for c in cols:
        n = 0; mx = 0.0; mxr = 0.0; worst = ""
        for k in common:
            va, vb = idxA[k].get(c), idxB[k].get(c)
            if not (is_num(va) and is_num(vb)):
                continue
            fa, fb = float(va), float(vb); d = abs(fa - fb); n += 1
            r = d / abs(fa) if fa != 0 else (0.0 if d == 0 else float("inf"))
            if d > mx:
                mx, worst = d, "/".join(k)
            mxr = max(mxr, r)
        ok = (mx <= a.tol) or (a.rel_tol and mxr <= a.rel_tol)
        if n and not ok:
            fail = True
        report.append(f"| `{c}` | {n} | {mx:.3e} | {mxr:.3e} | {worst} | {'✅' if ok or n == 0 else '❌'} |")
    if only_a:
        fail = True; report.append(f"\n❌ rows only in canonical ({len(only_a)}): " + "; ".join("/".join(k) for k in only_a[:10]))
    if only_b:
        fail = True; report.append(f"\n❌ rows only in candidate ({len(only_b)}): " + "; ".join("/".join(k) for k in only_b[:10]))
    report.append(f"\n**Verdict: {'FAIL' if fail else 'PASS'}** — " + ("differences exceed tolerance or rows are missing; explain each before calling anything reproduced." if fail else "every compared column within tolerance."))
    text = "\n".join(report) + "\n"
    print(text)
    if a.out:
        Path(a.out).parent.mkdir(parents=True, exist_ok=True); Path(a.out).write_text(text, encoding="utf-8"); print(f"report → {a.out}")
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main())
