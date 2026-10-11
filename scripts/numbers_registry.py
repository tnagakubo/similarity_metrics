#!/usr/bin/env python3
"""
numbers_registry.py — "numbers are generated, never typed" (RESEARCH_FRAMEWORK S5/S12).

A project keeps ONE registry CSV (default: <project>/paper/numbers_registry.csv) whose rows map a
macro key to a value computed from a canonical results CSV:

    key,source_file,filter,column,agg,fmt,scale,note[,line,token,occ]

  key          [A-Za-z][A-Za-z0-9.-]*   used in LaTeX as \\numval{key}, in Quarto as `r num("key")`
  source_file  path relative to the project root (e.g. results/w1_raw_summary.csv)
  filter       col=val;col2=v1|v2        string equality after trimming (numeric strings compare as numbers);
                                        '|' = alternatives; empty = all rows
  column       column to read
  agg          value (exactly one row) | min | max | mean | sum | n | range  (range → "min--max")
  fmt          d | ,d | {,}d | .Nf | .Ng   with optional modifiers after '!': m (wrap a negative in $…$), a (abs)
  scale        multiplier applied before formatting (default 1)
  line,token,occ  optional audit-trail columns written by `numbers_audit.py --draft-registry` and used by
                  `verify-draft` / `apply` (the literal `token` at the `occ`-th occurrence on `line` of the .tex)

The same semantics are implemented in R (scripts/r/numbers_registry.R → scripts/make_numbers_macros.R);
`check` asserts the two implementations agree, which is the four-eyes principle applied to the generator.

Subcommands
  build  REGISTRY --out MACROS.tex            write the LaTeX macro file (fallback generator; R is canonical)
  check  REGISTRY --macros MACROS.tex [--tex PAPER.tex]
                                              recompute every key, compare with the macro file; with --tex also
                                              list \\numval keys the paper uses but the registry lacks, and
                                              registry keys the paper never uses. exit 1 on any mismatch/undefined
  verify-draft REGISTRY --tex PAPER.tex       for rows with a source: compare the computed value with the literal
                                              `token` found in the .tex (numbers verification, mechanical half)
  apply  REGISTRY --tex PAPER.tex [--out OUT.tex] [--keys k1,k2]
                                              replace each row's literal token (line/occ) with \\numval{key};
                                              refuses when the token is not where the registry says it is
  value  REGISTRY KEY                         print one formatted value
"""
import argparse
import csv
import os
import re
import sys
from pathlib import Path

KEY_RE = re.compile(r"^[A-Za-z][A-Za-z0-9.-]*$")
MACRO_LINE_RE = re.compile(r"\\expandafter\\def\\csname lab@num@([A-Za-z0-9.-]+)\\endcsname\{(.*)\}\s*$")
NUMVAL_RE = re.compile(r"\\numval\{([A-Za-z0-9.-]+)\}")


class RegistryError(Exception):
    pass


def project_root_for(registry_path: Path) -> Path:
    # registry lives in <project>/paper/ by convention; fall back to its own directory
    p = registry_path.resolve().parent
    return p.parent if p.name == "paper" else p


def read_registry(path: Path):
    rows = []
    with path.open(newline="", encoding="utf-8") as fh:
        for i, r in enumerate(csv.DictReader(fh), start=2):
            if not r.get("key") or r["key"].strip().startswith("#"):
                continue
            r = {k: (v.strip() if isinstance(v, str) else v) for k, v in r.items()}
            r["_line"] = i
            rows.append(r)
    return rows


_csv_cache = {}


def load_csv(root: Path, rel: str):
    p = (root / rel)
    if p not in _csv_cache:
        if not p.exists():
            raise RegistryError(f"source file not found: {rel}")
        with p.open(newline="", encoding="utf-8") as fh:
            _csv_cache[p] = list(csv.DictReader(fh))
    return _csv_cache[p]


def _eq(cell: str, want: str) -> bool:
    cell, want = (cell or "").strip(), want.strip()
    if cell == want:
        return True
    try:
        return abs(float(cell) - float(want)) < 1e-12
    except ValueError:
        return False


def parse_filter(flt: str):
    conds = []
    for part in [p for p in (flt or "").split(";") if p.strip()]:
        if "=" not in part:
            raise RegistryError(f"bad filter clause '{part}'")
        col, val = part.split("=", 1)
        conds.append((col.strip(), [v for v in val.split("|")]))
    return conds


def select_rows(rows, flt):
    conds = parse_filter(flt)
    out = []
    for r in rows:
        ok = True
        for col, alts in conds:
            if col not in r:
                raise RegistryError(f"filter column '{col}' not in source")
            if not any(_eq(r[col], a) for a in alts):
                ok = False
                break
        if ok:
            out.append(r)
    return out


def to_float(s: str, where: str) -> float:
    try:
        return float(str(s).strip())
    except ValueError:
        raise RegistryError(f"non-numeric cell '{s}' at {where}")


def round_dec(x: float, dp: int) -> str:
    """Round half to EVEN on the decimal value (15 significant digits), not on the binary double.

    Why: 0.9425 (= 9425/10000, a coverage with an exact decimal tie) printed as 0.942 on one machine and 0.943 on
    another with the same formatC/printf code, because the nearest double lies a hair above 0.9425 on IEEE
    platforms that round exactly, while other runtimes round the shortest decimal string. The registry therefore
    defines ONE rule — IEC 60559 round-half-even applied to the 15-significant-digit decimal representation —
    and implements it identically in Python and R (scripts/r/numbers_registry.R::.num_round_dec)."""
    from decimal import Decimal, ROUND_HALF_EVEN
    d = Decimal(format(x, ".15g")).quantize(Decimal(1).scaleb(-dp), rounding=ROUND_HALF_EVEN)
    s = f"{d:f}"
    if dp == 0:
        s = s.split(".")[0]
    if s.startswith("-") and float(s) == 0:
        s = s[1:]  # no "-0.000"
    return s


def fmt_number(x: float, fmt: str) -> str:
    base, _, mods = fmt.partition("!")
    if "a" in mods:
        x = abs(x)
    if base == "d":
        s = round_dec(x, 0)
    elif base == ",d":
        s = f"{int(round_dec(x, 0)):,}"
    elif base == "{,}d":
        s = f"{int(round_dec(x, 0)):,}".replace(",", "{,}")
    elif re.fullmatch(r"\.\d+f", base):
        s = round_dec(x, int(base[1:-1]))
    elif re.fullmatch(r"\.\d+g", base):
        s = f"{x:{base}}"
    else:
        raise RegistryError(f"unknown fmt '{fmt}'")
    if "m" in mods and s.startswith("-"):
        s = f"${s}$"
    return s


def compute(row, root: Path) -> str:
    key = row["key"]
    if not KEY_RE.match(key):
        raise RegistryError(f"bad key '{key}' (allowed: letters, digits, '.', '-')")
    src = load_csv(root, row["source_file"])
    sel = select_rows(src, row.get("filter", ""))
    col = row["column"]
    if sel and col not in sel[0]:
        raise RegistryError(f"{key}: column '{col}' not in {row['source_file']}")
    agg = (row.get("agg") or "value").lower()
    scale = float(row.get("scale") or 1)
    fmt = row.get("fmt") or ".3f"
    where = f"{key} ({row['source_file']} [{row.get('filter','')}] {col})"
    vals = [to_float(r[col], where) * scale for r in sel]
    if agg == "value":
        if len(sel) != 1:
            raise RegistryError(f"{key}: filter selects {len(sel)} rows, 'value' needs exactly 1")
        return fmt_number(vals[0], fmt)
    if not vals:
        raise RegistryError(f"{key}: filter selects 0 rows")
    if agg == "min":
        return fmt_number(min(vals), fmt)
    if agg == "max":
        return fmt_number(max(vals), fmt)
    if agg == "mean":
        return fmt_number(sum(vals) / len(vals), fmt)
    if agg == "sum":
        return fmt_number(sum(vals), fmt)
    if agg == "n":
        return fmt_number(len(vals), fmt if fmt.startswith(("d", ",d", "{,}d")) else "d")
    if agg == "range":
        return f"{fmt_number(min(vals), fmt)}--{fmt_number(max(vals), fmt)}"
    raise RegistryError(f"{key}: unknown agg '{agg}'")


def compute_all(rows, root: Path):
    values, errors = {}, []
    for r in rows:
        try:
            values[r["key"]] = compute(r, root)
        except RegistryError as e:
            errors.append(str(e))
    dup = {k for k in [r["key"] for r in rows] if [r["key"] for r in rows].count(k) > 1}
    for k in sorted(dup):
        errors.append(f"duplicate key '{k}'")
    return values, errors


def render_macros(values: dict, registry_rel: str, generator: str) -> str:
    out = [f"% numbers_macros.tex — GENERATED from {registry_rel} (Rscript scripts/make_numbers_macros.R, cross-checked by scripts/numbers_registry.py). Do not edit by hand.",
           "% Usage in the manuscript: \\numval{key}. Regenerate: Rscript scripts/make_numbers_macros.R <registry> <out>",
           "\\providecommand{\\numval}[1]{\\csname lab@num@#1\\endcsname}"]
    for k in sorted(values):
        out.append(f"\\expandafter\\def\\csname lab@num@{k}\\endcsname{{{values[k]}}}")
    return "\n".join(out) + "\n"


def parse_macros(path: Path) -> dict:
    vals = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        m = MACRO_LINE_RE.match(line.strip())
        if m:
            vals[m.group(1)] = m.group(2)
    return vals


def strip_tex_comments(text: str) -> str:
    return "\n".join(re.sub(r"(?<!\\)%.*", "", l) for l in text.splitlines())


def cmd_build(a):
    reg = Path(a.registry); root = project_root_for(reg)
    rows = read_registry(reg); values, errors = compute_all(rows, root)
    for e in errors:
        print(f"  ❌ {e}")
    Path(a.out).write_text(render_macros(values, os.path.relpath(reg, root), "scripts/numbers_registry.py build"), encoding="utf-8")
    print(f"numbers_registry: wrote {a.out} ({len(values)} macros, {len(errors)} error(s))")
    return 1 if errors else 0


def cmd_check(a):
    reg = Path(a.registry); root = project_root_for(reg)
    rows = read_registry(reg); values, errors = compute_all(rows, root)
    rc = 0
    for e in errors:
        print(f"  ❌ {e}"); rc = 1
    macros = parse_macros(Path(a.macros)) if a.macros else {}
    if a.macros:
        for k, v in sorted(values.items()):
            if k not in macros:
                print(f"  ❌ macro file lacks key '{k}' (regenerate)"); rc = 1
            elif macros[k] != v:
                print(f"  ❌ '{k}': macro file says {macros[k]!r}, registry computes {v!r} (regenerate; R and Python must agree)"); rc = 1
        for k in sorted(set(macros) - set(values)):
            print(f"  ⚠️ macro file has key '{k}' that the registry no longer defines"); rc = 1
    if a.tex:
        tex = strip_tex_comments(Path(a.tex).read_text(encoding="utf-8"))
        used = set(NUMVAL_RE.findall(tex))
        for k in sorted(used - set(values)):
            print(f"  ❌ paper uses \\numval{{{k}}} but the registry has no such key (LaTeX will fail)"); rc = 1
        unused = sorted(set(values) - used)
        if unused:
            print(f"  ℹ️ {len(unused)} registry key(s) not used in {Path(a.tex).name}: {', '.join(unused[:12])}{' …' if len(unused) > 12 else ''}")
        print(f"numbers_registry: {len(used)} key(s) used in {Path(a.tex).name}, {len(values)} defined")
    print("numbers_registry: check " + ("PASS" if rc == 0 else "FAIL"))
    return rc


def _find_token(line_text: str, token: str, occ: int):
    """Return (start, end) of the occ-th (1-based) occurrence of token as a standalone number."""
    pat = re.compile(r"(?<![A-Za-z0-9.\\{}])" + re.escape(token) + r"(?![0-9])")
    for i, m in enumerate(pat.finditer(line_text), start=1):
        if i == occ:
            return m.start(), m.end()
    return None


def cmd_verify_draft(a):
    reg = Path(a.registry); root = project_root_for(reg)
    rows = read_registry(reg)
    tex_lines = Path(a.tex).read_text(encoding="utf-8").splitlines()
    ok = bad = pending = 0
    for r in rows:
        if not r.get("source_file"):
            pending += 1; continue
        try:
            v = compute(r, root)
        except RegistryError as e:
            print(f"  ❌ {e}"); bad += 1; continue
        tok = r.get("token") or ""
        if tok:
            v_cmp = v.replace("{,}", ",").replace("$", "")
            t_cmp = tok.replace("{,}", ",").replace("\\%", "").replace("$", "")
            if v_cmp == t_cmp:
                ok += 1; print(f"  ✅ {r['key']:<28} L{r.get('line','?'):>4}  text {tok} = source {v}")
            else:
                bad += 1; print(f"  ⚠️ {r['key']:<28} L{r.get('line','?'):>4}  text {tok} ≠ source {v}   ← MISMATCH: decide which is wrong")
        else:
            ok += 1; print(f"  ✅ {r['key']:<28} = {v} (no text literal recorded)")
    print(f"numbers_registry: verify-draft — {ok} match, {bad} mismatch/error, {pending} rows without a source")
    return 1 if bad else 0


def cmd_apply(a):
    reg = Path(a.registry); root = project_root_for(reg)
    rows = read_registry(reg)
    only = set(a.keys.split(",")) if a.keys else None
    tex_path = Path(a.tex); lines = tex_path.read_text(encoding="utf-8").splitlines(keepends=True)
    applied, refused = 0, 0
    # apply from the bottom of each line rightwards-first is unnecessary: tokens replaced one at a time with re-search
    for r in rows:
        if only and r["key"] not in only:
            continue
        if not (r.get("line") and r.get("token")):
            continue
        ln = int(r["line"]); occ = int(r.get("occ") or 1)
        if ln < 1 or ln > len(lines):
            print(f"  ❌ {r['key']}: line {ln} out of range"); refused += 1; continue
        text = lines[ln - 1]
        if f"\\numval{{{r['key']}}}" in text:
            continue  # already applied
        pos = _find_token(text, r["token"], occ)
        if pos is None:
            print(f"  ❌ {r['key']}: token {r['token']!r} (occurrence {occ}) not found on L{ln}: {text.strip()[:80]}"); refused += 1; continue
        s, e = pos
        lines[ln - 1] = text[:s] + f"\\numval{{{r['key']}}}" + text[e:]
        applied += 1
    out = Path(a.out) if a.out else tex_path
    if applied and not a.dry_run:
        if out == tex_path:
            bak = tex_path.with_suffix(tex_path.suffix + ".bak_numbers")
            bak.write_text("".join(Path(a.tex).read_text(encoding="utf-8")), encoding="utf-8")
            print(f"  backup → {bak}")
        out.write_text("".join(lines), encoding="utf-8")
    print(f"numbers_registry: apply — {applied} replaced, {refused} refused{' (dry run)' if a.dry_run else ''}")
    return 1 if refused else 0


def cmd_value(a):
    reg = Path(a.registry); root = project_root_for(reg)
    rows = {r["key"]: r for r in read_registry(reg)}
    if a.key not in rows:
        print(f"no such key: {a.key}"); return 1
    print(compute(rows[a.key], root)); return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    s = sub.add_parser("build"); s.add_argument("registry"); s.add_argument("--out", required=True); s.set_defaults(fn=cmd_build)
    s = sub.add_parser("check"); s.add_argument("registry"); s.add_argument("--macros"); s.add_argument("--tex"); s.set_defaults(fn=cmd_check)
    s = sub.add_parser("verify-draft"); s.add_argument("registry"); s.add_argument("--tex", required=True); s.set_defaults(fn=cmd_verify_draft)
    s = sub.add_parser("apply"); s.add_argument("registry"); s.add_argument("--tex", required=True); s.add_argument("--out"); s.add_argument("--keys"); s.add_argument("--dry-run", action="store_true"); s.set_defaults(fn=cmd_apply)
    s = sub.add_parser("value"); s.add_argument("registry"); s.add_argument("key"); s.set_defaults(fn=cmd_value)
    a = ap.parse_args()
    try:
        return a.fn(a)
    except RegistryError as e:
        print(f"numbers_registry: ❌ {e}"); return 1


if __name__ == "__main__":
    sys.exit(main())
