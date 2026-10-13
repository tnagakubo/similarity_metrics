#!/usr/bin/env python3
"""
evidence_coverage.py — which results are billed by the paper, and which claims bind to what
(Mike's tool for /necessity; RESEARCH_FRAMEWORK S19).

A referee who recomputes from the repository finds two kinds of debt:
  * unbilled work — result files (the largest CSV in the project, an independent replication script)
    that no manuscript, supplement, registry, protocol or findings file mentions. Either they support a
    claim that should cite them or they are exploratory and must be labelled so;
  * unbacked claims — rows of CLAIMS.md whose evidence paths do not exist on disk, and included
    graphics that are missing (or figures on disk the paper never includes).

Usage:
  python3 scripts/evidence_coverage.py projects/{project} [--out FILE] [--strict]
  --strict  exit 1 when a CLAIMS.md evidence path is missing, an \\includegraphics target is missing,
            or the manuscript references a path under exploratory/
Advisory otherwise. Summary on line 1.
"""
import argparse
import csv
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

BILLING_DOCS = ["paper/*.tex", "paper/*.qmd", "paper/*.md", "paper/numbers_registry.csv", "results/NUMBERS_LEDGER.csv",
                "CLAIMS.md", "PROTOCOL_*.md", "SIMULATION_FINDINGS*.md", "results/*PROVENANCE*.md",
                "results/REPLICATION_*.md", "results/REPRODUCTION_*.md", "README.md", "MANIFEST.md",
                "R/make_paper_tables.R", "R/make_derived_numbers.R", "R/verify_*.R"]


def brace_expand(path: str) -> set:
    """results/x{,_ext}.csv → {results/x.csv, results/x_ext.csv} (one level is enough for CLAIMS.md)."""
    m = re.search(r"\{([^{}]*)\}", path)
    if not m:
        return {path}
    out = set()
    for alt in m.group(1).split(","):
        out |= brace_expand(path[:m.start()] + alt + path[m.end():])
    return out


def read(p: Path) -> str:
    try:
        return p.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return ""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("project")
    ap.add_argument("--out")
    ap.add_argument("--strict", action="store_true")
    a = ap.parse_args()
    proj = Path(a.project)
    if not proj.is_dir():
        sys.exit(f"evidence_coverage: not a directory: {proj}")
    repo_root = proj.resolve().parent.parent if proj.resolve().parent.name == "projects" else proj.resolve()

    billing_text = ""
    billing_files = []
    for pat in BILLING_DOCS:
        for p in proj.glob(pat):
            if p.is_file() and "numbers_macros" not in p.name and "/generated/" not in p.as_posix():
                billing_files.append(p)
                billing_text += "\n" + read(p)
    manuscripts = [p for p in proj.glob("paper/*.tex") if not re.search(r"supplement|template|numbers_macros", p.name)]
    man_text = "\n".join(read(p) for p in manuscripts)
    supp_text = "\n".join(read(p) for p in proj.glob("paper/supplement*") if p.suffix in (".tex", ".md", ".qmd"))

    # ---- results files ----------------------------------------------------------------------
    results = [p for p in sorted(proj.glob("results/**/*")) if p.is_file() and p.suffix.lower() in (".csv", ".rds", ".rda", ".rdata", ".json")]
    rows = []
    for p in results:
        name = p.name
        stem = p.stem
        in_man = name in man_text or f"{stem}." in man_text
        in_supp = name in supp_text
        in_bill = name in billing_text
        size_kb = p.stat().st_size / 1024
        rows.append((p.relative_to(proj).as_posix(), size_kb, in_man, in_supp, in_bill))
    unbilled = [r for r in rows if not r[4]]
    derived_only = [r for r in rows if r[4] and not (r[2] or r[3]) and "/derived/" not in r[0]]

    # ---- figures ----------------------------------------------------------------------------
    inc = re.findall(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]*)\}", man_text + supp_text)
    gp = re.search(r"\\graphicspath\{\{([^}]*)\}\}", man_text)
    figdir = (proj / "paper" / gp.group(1)).resolve() if gp else (proj / "figures")
    missing_graphics = []
    for g in inc:
        cands = [figdir / g] + [figdir / f"{g}{ext}" for ext in (".pdf", ".png", ".eps", ".jpg")] + [proj / "paper" / g]
        if not any(c.is_file() for c in cands):
            missing_graphics.append(g)
    on_disk = [p for p in sorted((proj / "figures").glob("*")) if p.suffix.lower() in (".pdf", ".png")] if (proj / "figures").is_dir() else []
    included_stems = {Path(g).stem for g in inc}
    unused_figs = sorted({p.stem for p in on_disk if p.stem not in included_stems and not p.stem.endswith("_color")})

    # ---- CLAIMS.md evidence paths --------------------------------------------------------------
    claims = proj / "CLAIMS.md"
    claim_rows, claim_missing, claim_single = [], [], []
    if claims.is_file():
        for line in read(claims).splitlines():
            m = re.match(r"^\|\s*(C-\d+)\s*\|(.*)$", line)
            if not m:
                continue
            cid = m.group(1)
            cells = [c.strip() for c in m.group(2).split("|")]
            ev = cells[2] if len(cells) > 2 else ""
            raw_paths = set(re.findall(r"`((?:results|R|data|figures|paper|knowledge)/[^`\s]+?)(?::[^`]*)?`", ev))
            raw_paths |= set(re.findall(r"(?<![\w/])((?:results|R|data|figures)/[A-Za-z0-9_./\-{},]+\.(?:csv|rds|R|pdf|png|md|tex))", ev))
            paths = set()
            for rp in raw_paths:
                paths |= brace_expand(rp)
            missing = sorted(p for p in paths if not (proj / p).exists() and not (repo_root / p).exists())
            claim_rows.append((cid, len(paths), missing))
            if missing:
                claim_missing.append((cid, missing))
            if len(paths) == 0 and cells[1].strip().lower() in ("simulation", "application"):
                claim_single.append(cid)

    # ---- exploratory leak ----------------------------------------------------------------------
    reg_text = "\n".join(read(p) for p in list(proj.glob("paper/numbers_registry.csv")) + list(proj.glob("results/NUMBERS_LEDGER.csv")))
    leak = sorted(set(re.findall(r"exploratory/[A-Za-z0-9_./\-]+", man_text + "\n" + supp_text + "\n" + reg_text)))

    # ---- R scripts never mentioned anywhere ----------------------------------------------------
    r_scripts = sorted(p for p in proj.glob("R/*.R"))
    billing_names = {p.name for p in billing_files}
    r_unmentioned = [p.name for p in r_scripts if p.name not in billing_names and p.name not in billing_text and p.name not in man_text]

    big_unbilled = sorted(unbilled, key=lambda r: -r[1])
    head = (f"evidence_coverage: {len(rows)} result files, {len(unbilled)} unbilled"
            + (f" (largest {big_unbilled[0][0]} {big_unbilled[0][1]:.0f} KB)" if big_unbilled else "")
            + f"; CLAIMS rows {len(claim_rows)}, evidence paths missing in {len(claim_missing)}; graphics missing {len(missing_graphics)}, "
            + f"figures unused {len(unused_figs)}; R scripts unmentioned {len(r_unmentioned)}/{len(r_scripts)}; exploratory leaks {len(leak)}")
    L = [f"# Evidence coverage — {proj.name}", "", head, ""]
    L.append("Billing documents scanned: " + ", ".join(sorted({p.relative_to(proj).as_posix() for p in billing_files})[:40]))
    L.append("")
    L.append("## 1. Result files — billed by the manuscript, a supplement, or any lifecycle document?")
    L.append("")
    L.append("| file | KB | manuscript | supplement | any doc |")
    L.append("|---|---:|:-:|:-:|:-:|")
    for rel, kb, im, isup, ib in sorted(rows, key=lambda r: (r[4], r[2], -r[1])):
        L.append(f"| {rel} | {kb:.0f} | {'✅' if im else '—'} | {'✅' if isup else '—'} | {'✅' if ib else '❌ unbilled'} |")
    L.append("")
    L.append(f"Unbilled: **{len(unbilled)}** file(s). Each is either evidence a claim should cite, or exploratory work to be labelled "
             "as such in README / an `exploratory/` folder (never silently omitted).")
    L.append("")
    L.append("## 2. Figures")
    L.append("")
    L.append(f"Included graphics: {len(inc)}; missing on disk: {', '.join(missing_graphics) if missing_graphics else 'none ✅'}")
    L.append(f"Figures on disk never included (non-colour stems): {', '.join(unused_figs) if unused_figs else 'none ✅'}")
    L.append("")
    L.append("## 3. CLAIMS.md — evidence paths on disk")
    L.append("")
    if claim_rows:
        L.append(f"Rows: {len(claim_rows)}; rows with a missing evidence path: {len(claim_missing)}; "
                 f"simulation/application rows citing no file path: {', '.join(claim_single) if claim_single else 'none ✅'}")
        for cid, miss in claim_missing:
            L.append(f"- ❌ {cid}: {', '.join(miss)}")
    else:
        L.append("No CLAIMS.md (run /claims init).")
    L.append("")
    L.append("## 4. Exploratory leak — references under exploratory/ in the manuscript, supplements, numbers registry or ledger")
    L.append("")
    L.append(", ".join(leak) if leak else "none ✅")
    L.append("")
    L.append("## 5. R scripts mentioned nowhere (manuscript, registry, protocols, provenance, verify scripts)")
    L.append("")
    L.append(", ".join(r_unmentioned) if r_unmentioned else "none ✅")
    L.append("")
    report = "\n".join(L)
    if a.out:
        Path(a.out).parent.mkdir(parents=True, exist_ok=True)
        Path(a.out).write_text(report, encoding="utf-8")
        print(head)
        print(f"report → {a.out}")
    else:
        print(report)
    sys.exit(1 if (a.strict and (claim_missing or missing_graphics or leak)) else 0)


if __name__ == "__main__":
    main()
