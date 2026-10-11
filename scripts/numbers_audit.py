#!/usr/bin/env python3
"""
numbers_audit.py — Numbers Verification Gate, mechanical half (Mike's tool).

Extracts every quantitative token from a LaTeX manuscript (prose and math, preamble and
comments excluded) and reconciles it against a numbers ledger CSV
(default: <project>/results/NUMBERS_LEDGER.csv) whose columns are

    value,label,source_file,source_locator,verified_by,verified_date,note

A number is "sourced" when its normalised value equals a ledger value, or rounds to it at
the ledger's precision. Structural numbers (years in citation position, Table/Figure/
Section/Study/Scenario/Region numbers, label/ref/cite arguments, graphics options,
small integers inside math) are excluded; everything else is reported.

Usage:
  python3 scripts/numbers_audit.py paper.tex [--ledger results/NUMBERS_LEDGER.csv]
                                             [--draft-ledger out.csv] [--all] [--strict]

  --all           list sourced numbers too (default: unsourced only)
  --draft-ledger  write a CSV skeleton of the unsourced numbers for Mike to fill
  --strict        exit 1 when unsourced numbers remain

This is an aid, not a judge: Mike (producer) and a second member (Katrina or Louis,
verifier) still re-derive each value. The ledger records who verified what, when.
"""
import argparse
import csv
import re
import signal
import sys
from pathlib import Path

STRUCT_WORDS = (r"Table|Tables|Figure|Figures|Fig\.|Section|Sections|§|Study|Studies|Scenario|Scenarios|"
                r"Region|Regions|Reviewer|Step|Steps|Supplement|Appendix|Eq\.|Equation|Proposition|Theorem|"
                r"Lemma|Corollary|Remark|Chapter|Part|Phase|Round|Item|Version|v|ICH E|E")
STRUCT_RE = re.compile(rf"(?:{STRUCT_WORDS})\s*~?\s*\\?(?:ref\{{[^}}]*\}})?\(?\d+(?:\.\d+)?\)?[A-Za-z]?")
YEAR_RE = re.compile(r"(?<=[(\s~,;])(1[89]\d{2}|20\d{2})(?=[),;\s.]|$)")
CMD_DROP = [
    r"\\label\{[^}]*\}", r"\\(?:eq|auto|c|C|page|name)?ref\*?\{[^}]*\}", r"\\(?:no)?cite[a-zA-Z*]*(?:\[[^\]]*\])*\{[^}]*\}",
    r"\\includegraphics(?:\[[^\]]*\])?\{[^}]*\}", r"\\begin\{[^}]*\}(?:\{[^}]*\})?(?:\[[^\]]*\])?", r"\\end\{[^}]*\}",
    r"\\(?:v|h)space\*?\{[^}]*\}", r"\\setcounter\{[^}]*\}\{[^}]*\}", r"\\(?:small|foot|script)?skip",
    r"\\(?:multicolumn|multirow)\{\d+\}", r"\\(?:cline|cmidrule)(?:\([^)]*\))?\{[^}]*\}",
    r"\\(?:url|href)\{[^}]*\}", r"\\input\{[^}]*\}", r"\\bibliography(?:style)?\{[^}]*\}",
    r"\\(?:text|math)(?:bf|it|rm|sf|tt)", r"\\(?:resizebox|scalebox)\{[^}]*\}(?:\{[^}]*\})?",
    r"\\(?:hline|toprule|midrule|bottomrule|noindent|centering|newline)",
    r"\\(?:column|table|text)width", r"\\(?:caption|footnote)mark",
    r"\\(?:keywords?|jnlcitation|cgs|cgsn|corres|articletype|received|revised|accepted|fundingInfo)\{",
    r"\\(?:affil|affiliation|author|authfn)\[[^\]]*\]", r"doi:\s*\S+", r"10\.\d{4,9}/\S+",
    r"\\(?:cvol|jnlcitation|cyear|cpages)\{[^}]*\}", r"\b\d+\.\d+\.\d+(?:\.\d+)*\b",
    r"\\(?:date)\{[^}]*\}", r"\\documentclass(?:\[[^\]]*\])?\{[^}]*\}", r"\\usepackage(?:\[[^\]]*\])?\{[^}]*\}",
    r"\\newcommand\*?\{[^}]*\}(?:\[\d\])?", r"\\renewcommand\*?\{[^}]*\}(?:\[\d\])?",
    r"\\(?:lccode|catcode|uccode)[^\n]*", r"\\(?:arrayrulewidth|tabcolsep|arraystretch)[^\n]*",
]
CMD_DROP_RE = [re.compile(p) for p in CMD_DROP]
NUM_RE = re.compile(r"(?<![A-Za-z_\\{}#\d.])(?:\d{1,3}(?:,\d{3})+|\d+)(?:\.\d+)?(?:\s*\\?%)?|(?<![\w.])\.\d+(?:\s*\\?%)?")


def strip_comments(line: str) -> str:
    out, i = [], 0
    while i < len(line):
        c = line[i]
        if c == "\\" and i + 1 < len(line):
            out.append(line[i:i + 2]); i += 2; continue
        if c == "%":
            break
        out.append(c); i += 1
    return "".join(out)


def normalise(tok: str) -> str:
    t = tok.replace(",", "").replace("\\", "").replace("%", "").strip()
    if t.startswith("."):
        t = "0" + t
    try:
        f = float(t)
    except ValueError:
        return t
    return repr(f) if "." in t else str(int(f))


def decimals(s: str) -> int:
    return len(s.split(".")[1]) if "." in s else 0


def round_dec(x: float, dp: int) -> float:
    """The lab's one rounding rule (decimal round-half-even on the 15-significant-digit value; see
    scripts/numbers_registry.py::round_dec and DECISIONS D-20261011-2) — 0.9425 → 0.942, never 0.943."""
    from decimal import Decimal, ROUND_HALF_EVEN
    return float(Decimal(format(x, ".15g")).quantize(Decimal(1).scaleb(-dp), rounding=ROUND_HALF_EVEN))


def load_ledger(path: Path):
    rows = []
    if not path or not path.exists():
        return rows
    with path.open(newline="", encoding="utf-8") as fh:
        for r in csv.DictReader(fh):
            v = (r.get("value") or "").strip()
            if v and not v.startswith("#"):
                r["_norm"] = normalise(v)
                r["_dec"] = decimals(v.replace(",", ""))
                rows.append(r)
    return rows


def match_ledger(norm: str, ledger):
    """A token is sourced by a ledger row when the two values are equal, or when the LEDGER value — recorded at
    higher precision — rounds to the token at the token's own precision (ledger 0.9425, text 0.943). Never the other
    way round: a coarse design constant (0.5, 0.9, 1.0) must not absorb nearby results (0.46, 0.862, 0.95)."""
    for r in ledger:
        if r["_norm"] == norm:
            return r
    try:
        f = float(norm)
    except ValueError:
        return None
    dec_tok = decimals(norm)
    for r in ledger:
        try:
            lv = float(r["_norm"])
        except ValueError:
            continue
        if abs(f - lv) < 1e-9 or (r["_dec"] > dec_tok and abs(round_dec(lv, dec_tok) - f) < 1e-9):
            return r
    return None


def in_math_segments(line: str):
    """Yield (segment, is_math). Handles $...$, \\(...\\), \\[...\\] on one line; display
    environments are treated as prose with the small-integer filter applied via heuristics."""
    segs, i, buf, math = [], 0, [], False
    while i < len(line):
        if line.startswith("$$", i):
            segs.append(("".join(buf), math)); buf = []; math = not math; i += 2; continue
        if line[i] == "$":
            segs.append(("".join(buf), math)); buf = []; math = not math; i += 1; continue
        if line.startswith("\\(", i) or line.startswith("\\[", i):
            segs.append(("".join(buf), math)); buf = []; math = True; i += 2; continue
        if line.startswith("\\)", i) or line.startswith("\\]", i):
            segs.append(("".join(buf), math)); buf = []; math = False; i += 2; continue
        buf.append(line[i]); i += 1
    segs.append(("".join(buf), math))
    return segs


QMD_CHUNK_RE = re.compile(r"^```\{.*?^```\s*$", re.S | re.M)
QMD_INLINE_RE = re.compile(r"`r [^`]*`|`\{r\}[^`]*`")
QMD_FRONT_RE = re.compile(r"\A---\s*\n.*?\n---\s*\n", re.S)
NUMVAL_USE_RE = re.compile(r"\\numval\{[A-Za-z0-9.-]+\}")


def extract(tex_path: Path):
    text = tex_path.read_text(encoding="utf-8", errors="replace")
    if tex_path.suffix.lower() == ".qmd":
        # Quarto: numbers inside R chunks / inline `r …` are computed, hence sourced by construction.
        # Blank them out (keep line count) so only typed literals in prose are reported.
        def blank(m):
            return "\n" * m.group(0).count("\n")
        text = QMD_FRONT_RE.sub(blank, text)
        text = QMD_CHUNK_RE.sub(blank, text)
        text = QMD_INLINE_RE.sub(" ", text)
    # \numval{key} is a registry lookup → sourced by construction
    text = NUMVAL_USE_RE.sub(" ", text)
    lines = text.splitlines()
    # skip preamble
    body_start = 0
    for i, l in enumerate(lines):
        if "\\begin{document}" in l:
            body_start = i + 1
            break
    found = []
    math_env = False
    for idx in range(body_start, len(lines)):
        raw = lines[idx]
        line = strip_comments(raw)
        if not line.strip():
            continue
        if re.search(r"\\begin\{(equation|align|gather|eqnarray|multline|displaymath)\*?\}", line):
            math_env = True
        line = line.replace("{,}", ",").replace("\\,", "")
        for pat in CMD_DROP_RE:
            line = pat.sub(" ", line)
        line = STRUCT_RE.sub(" ", line)
        line = YEAR_RE.sub(" ", line)
        for seg, is_math in in_math_segments(line):
            is_math = is_math or math_env
            for m in NUM_RE.finditer(seg):
                tok = m.group(0).strip()
                norm = normalise(tok)
                has_pct = "%" in tok
                is_int = "." not in norm
                try:
                    val = float(norm)
                except ValueError:
                    continue
                if is_math and is_int and abs(val) < 100 and not has_pct:
                    continue  # exponents, subscripts, fractions, small grid constants inside math
                if (not is_math) and is_int and abs(val) < 10 and not has_pct:
                    # small counts in prose: keep only when written as an explicit value (= 7, n = 5)
                    ctx = seg[max(0, m.start() - 4):m.start()]
                    if "=" not in ctx:
                        continue
                start = max(0, m.start() - 36)
                end = min(len(seg), m.end() + 24)
                ctx = re.sub(r"\s+", " ", seg[start:end]).strip()
                found.append({"line": idx + 1, "token": tok, "norm": norm, "math": is_math, "context": ctx})
        if re.search(r"\\end\{(equation|align|gather|eqnarray|multline|displaymath)\*?\}", line):
            math_env = False
    return found


def main():
    try:
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # allow `| head`
    except (AttributeError, ValueError):
        pass
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tex")
    ap.add_argument("--ledger", default=None)
    ap.add_argument("--draft-ledger", default=None)
    ap.add_argument("--draft-registry", default=None, help="write a numbers_registry.csv skeleton (key=TODO, line/token/occ filled) for Mike to source")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--strict", action="store_true")
    args = ap.parse_args()
    tex = Path(args.tex)
    if not tex.exists():
        print(f"numbers_audit: {tex} not found", file=sys.stderr); return 2
    ledger_path = Path(args.ledger) if args.ledger else None
    if ledger_path is None:
        # default: <project>/results/NUMBERS_LEDGER.csv  (paper/ is a sibling of results/)
        cand = tex.parent.parent / "results" / "NUMBERS_LEDGER.csv"
        ledger_path = cand if cand.exists() else None
    ledger = load_ledger(ledger_path) if ledger_path else []
    found = extract(tex)
    unsourced, sourced = [], []
    for f in found:
        r = match_ledger(f["norm"], ledger)
        (sourced if r else unsourced).append((f, r))
    distinct_uns = sorted({f["norm"] for f, _ in unsourced}, key=lambda s: float(s) if re.match(r"^-?\d", s) else 0)
    print(f"Mike: numbers audit of {tex.name} — {len(found)} numeric tokens, "
          f"{len(sourced)} sourced, {len(unsourced)} unsourced ({len(distinct_uns)} distinct values)."
          + (f" Ledger: {ledger_path} ({len(ledger)} rows)" if ledger_path else " Ledger: none found"))
    if args.all and sourced:
        print("\n## Sourced")
        for f, r in sourced:
            print(f"  ✅ L{f['line']:>4}  {f['token']:>12}  ← {r.get('source_file','')}:{r.get('source_locator','')} "
                  f"[{r.get('verified_by','')} {r.get('verified_date','')}]  …{f['context']}…")
    if unsourced:
        print("\n## Unsourced (❓) — each needs a ledger row or an exclusion reason")
        for f, _ in unsourced:
            flag = "math" if f["math"] else "text"
            print(f"  ❓ L{f['line']:>4}  {f['token']:>12}  ({flag})  …{f['context']}…")
    if args.draft_ledger:
        out = Path(args.draft_ledger)
        seen = set()
        with out.open("w", newline="", encoding="utf-8") as fh:
            w = csv.writer(fh)
            w.writerow(["value", "label", "source_file", "source_locator", "verified_by", "verified_date", "note"])
            for f, _ in unsourced:
                key = (f["norm"], f["line"])
                if key in seen:
                    continue
                seen.add(key)
                w.writerow([f["token"], f"L{f['line']}: {f['context']}", "", "", "", "", ""])
        print(f"\nDraft ledger written: {out} ({len(seen)} rows). Fill source_file/source_locator; "
              f"verifier must differ from producer (four-eyes).")
    if args.draft_registry:
        out = Path(args.draft_registry)
        # occurrence index of the same token on the same line
        seen_on_line = {}
        with out.open("w", newline="", encoding="utf-8") as fh:
            w = csv.writer(fh)
            w.writerow(["key", "source_file", "filter", "column", "agg", "fmt", "scale", "note", "line", "token", "occ"])
            for f, _ in unsourced:
                tok = f["token"].replace("\\%", "").strip()
                k = (f["line"], tok)   # literal token, as numbers_registry.apply searches for it (not the normalised value)
                seen_on_line[k] = seen_on_line.get(k, 0) + 1
                dec = len(tok.split(".")[1]) if "." in tok else 0
                fmt = f".{dec}f" if dec else ("{,}d" if "," in tok else "d")
                w.writerow([f"TODO.L{f['line']}.{seen_on_line[k]}", "", "", "", "value", fmt, "1",
                            f"L{f['line']}: {f['context']}", f["line"], tok, seen_on_line[k]])
        print(f"\nDraft registry written: {out} ({len(unsourced)} rows). Name the keys, fill source_file/filter/column; "
              f"then: numbers_registry.py verify-draft → apply → build/check.")
    return 1 if (unsourced and args.strict) else 0


if __name__ == "__main__":
    sys.exit(main())
