#!/usr/bin/env python3
"""
cite_audit.py — citation integrity audit, mechanical half (Rachel's tool; Rule 2.6).

Reconciles \\cite keys in a LaTeX manuscript against a BibTeX file and reports
  1. keys cited but absent from the .bib            (compile-time undefined citations)
  2. .bib entries never cited                        (dead weight; fine for the knowledge base, not for the paper)
  3. cited entries without a DOI                      (Rule 2.6; books/guidelines may use URL/ISBN instead — flagged, not failed)
  4. malformed or duplicated DOIs
  5. a skeleton table — one row per cited key with the sentence of first citation —
     for Rachel to complete the two columns a machine cannot: "supports the claim?" and
     "verbatim supporting passage (page)".

Usage:
  python3 scripts/cite_audit.py paper.tex paper.bib [--out review_response/CITATION_AUDIT_YYYYMMDD.md] [--strict]
"""
import argparse
import re
import sys
from datetime import date
from pathlib import Path

CITE_RE = re.compile(r"\\(?:no)?[cC]ite[a-zA-Z*]*(?:\[[^\]]*\])*\{([^}]+)\}")
DOI_RE = re.compile(r"^10\.\d{4,9}/\S+$")
NO_DOI_TYPES = {"book", "manual", "misc", "techreport", "unpublished", "booklet", "incollection", "inbook", "online"}


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


def parse_bib(path: Path):
    text = path.read_text(encoding="utf-8", errors="replace")
    entries = {}
    order = []
    i = 0
    while True:
        at = text.find("@", i)
        if at < 0:
            break
        m = re.match(r"@(\w+)\s*[{(]\s*([^,\s]+)\s*,", text[at:])
        if not m:
            i = at + 1
            continue
        etype, key = m.group(1).lower(), m.group(2)
        if etype in ("comment", "preamble", "string"):
            i = at + 1
            continue
        # find matching closing brace
        depth, j = 0, at
        while j < len(text):
            if text[j] == "{":
                depth += 1
            elif text[j] == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        body = text[at:j + 1]
        fields = {}
        for fm in re.finditer(r"(\w+)\s*=\s*(\{(?:[^{}]|\{[^{}]*\})*\}|\"[^\"]*\"|[^,\n]+)", body[m.end():]):
            name = fm.group(1).lower()
            val = fm.group(2).strip().strip("{}\"").strip()
            fields[name] = val
        if key in entries:
            entries[key]["_dup"] = True
        else:
            entries[key] = {"type": etype, "fields": fields, "_dup": False}
            order.append(key)
        i = j + 1
    return entries, order


def first_sentence_for(lines, lineno, key):
    """Return the sentence (±1 line) that carries the first \\cite of `key`."""
    ctx = " ".join(strip_comments(l) for l in lines[max(0, lineno - 2):lineno + 1])
    ctx = re.sub(r"\s+", " ", ctx)
    pos = ctx.find(key)
    if pos < 0:
        return ctx[:220]
    start = max(ctx.rfind(". ", 0, pos), ctx.rfind("。", 0, pos))
    start = start + 2 if start >= 0 else max(0, pos - 160)
    end = ctx.find(". ", pos)
    end = end + 1 if end >= 0 else min(len(ctx), pos + 160)
    return ctx[start:end].strip()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tex")
    ap.add_argument("bib")
    ap.add_argument("--out", default=None, help="write the audit (markdown) here")
    ap.add_argument("--strict", action="store_true", help="exit 1 on missing keys or missing DOIs for article/journal entries")
    args = ap.parse_args()
    tex, bib = Path(args.tex), Path(args.bib)
    for p in (tex, bib):
        if not p.exists():
            print(f"cite_audit: {p} not found", file=sys.stderr); return 2
    lines = tex.read_text(encoding="utf-8", errors="replace").splitlines()
    cited_first = {}
    for idx, raw in enumerate(lines):
        for m in CITE_RE.finditer(strip_comments(raw)):
            for key in (k.strip() for k in m.group(1).split(",")):
                if key and key not in cited_first:
                    cited_first[key] = idx
    entries, order = parse_bib(bib)
    missing = [k for k in cited_first if k not in entries]
    uncited = [k for k in order if k not in cited_first]
    dups = [k for k, e in entries.items() if e["_dup"]]
    no_doi, bad_doi, doi_seen, doi_dup = [], [], {}, []
    for k in cited_first:
        e = entries.get(k)
        if not e:
            continue
        doi = e["fields"].get("doi", "").replace("https://doi.org/", "").replace("http://dx.doi.org/", "").strip()
        if not doi:
            no_doi.append((k, e["type"], e["fields"].get("url", "") or e["fields"].get("isbn", "")))
        else:
            if not DOI_RE.match(doi):
                bad_doi.append((k, doi))
            if doi.lower() in doi_seen:
                doi_dup.append((k, doi_seen[doi.lower()], doi))
            doi_seen[doi.lower()] = k

    hard_fail = bool(missing) or any(t not in NO_DOI_TYPES for _, t, _ in no_doi)
    out = []
    out.append(f"# Citation audit — {tex.name} vs {bib.name} ({date.today().isoformat()})\n")
    out.append(f"- cited keys: **{len(cited_first)}** · bib entries: **{len(entries)}** · "
               f"cited-but-missing: **{len(missing)}** · uncited: **{len(uncited)}** · "
               f"cited without DOI: **{len(no_doi)}** · malformed DOI: **{len(bad_doi)}** · "
               f"duplicate DOI: **{len(doi_dup)}** · duplicate keys: **{len(dups)}**\n")
    if missing:
        out.append("## ❌ Cited but not in .bib\n" + "\n".join(f"- `{k}` (first at L{cited_first[k]+1})" for k in missing) + "\n")
    if no_doi:
        out.append("## 🔍 Cited entries without DOI (Rule 2.6)\n| key | type | url / isbn | action |\n|---|---|---|---|\n" +
                   "\n".join(f"| `{k}` | {t} | {u or '—'} | {'URL/ISBN acceptable for this type — confirm the link resolves' if t in NO_DOI_TYPES else 'find DOI (Crossref/PubMed); never invent one'} |"
                             for k, t, u in no_doi) + "\n")
    if bad_doi:
        out.append("## ⚠️ Malformed DOI\n" + "\n".join(f"- `{k}`: `{d}`" for k, d in bad_doi) + "\n")
    if doi_dup:
        out.append("## ⚠️ Two keys share one DOI (likely duplicate entries)\n" + "\n".join(f"- `{a}` and `{b}`: `{d}`" for a, b, d in doi_dup) + "\n")
    if dups:
        out.append("## ⚠️ Duplicate keys in .bib\n" + "\n".join(f"- `{k}`" for k in dups) + "\n")
    if uncited:
        out.append("## ℹ️ In .bib but never cited\n" + ", ".join(f"`{k}`" for k in uncited) + "\n")
    out.append("## Citation–claim table (Rachel completes the last two columns from the source PDF)\n")
    out.append("| key | first cited | sentence in manuscript | supports the claim? | verbatim passage (page) |\n|---|---|---|---|---|")
    for k, idx in sorted(cited_first.items(), key=lambda kv: kv[1]):
        sent = first_sentence_for(lines, idx, k).replace("|", "\\|")
        out.append(f"| `{k}` | L{idx+1} | {sent[:200]} |  |  |")
    report = "\n".join(out) + "\n"
    if args.out:
        Path(args.out).parent.mkdir(parents=True, exist_ok=True)
        Path(args.out).write_text(report, encoding="utf-8")
        print(f"Rachel: citation audit written → {args.out}")
    # console summary
    print(report.split("\n## Citation–claim table")[0])
    return 1 if (args.strict and hard_fail) else 0


if __name__ == "__main__":
    sys.exit(main())
