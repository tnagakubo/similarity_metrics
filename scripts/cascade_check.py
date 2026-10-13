#!/usr/bin/env python3
"""
cascade_check.py — second-order review of a fix: did the correction cascade, and did compression
drop a qualifier? (Louis's tool for /review-fix; RESEARCH_FRAMEWORK S18)

Two failure modes seen in this project's own history:
  * patch without cascade — a claim corrected in the sentence a referee quoted survived, verbatim or
    reworded, at three other sites;
  * compression drops the qualifier — "in at least one world" became "wherever", and a restricting
    phrase was deleted, when the abstract was shortened.

Given an old and a new version of the manuscript, the script
  1. pairs each removed sentence with its closest added sentence (modified) or marks it deleted;
  2. for every modified / deleted sentence, lists UNCHANGED sentences elsewhere that still carry the
     removed wording (content-word overlap with the old sentence, and ≥ 2 of the words the fix dropped)
     → candidate sites the cascade missed;
  3. for every modified pair, lists hedges present in the old sentence and absent in the new
     (qualifier dropped) and universal quantifiers present in the new and absent in the old
     (claim strengthened).

Usage:
  python3 scripts/cascade_check.py --old <rev|file> --new <rev|file> [--tex projects/p/paper/x.tex]
                                   [--jaccard 0.35] [--min-shared 4] [--out FILE] [--strict]
  --old/--new   a git revision (file path taken from --tex) or a path to a .tex file
  --strict      exit 1 when any candidate residue site or dropped qualifier remains
Advisory otherwise. Summary on line 1.
"""
import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import texprose as tp  # noqa: E402


def read_version(spec: str, tex: str | None) -> tuple[str, str]:
    p = Path(spec)
    if p.is_file():
        return p.read_text(encoding="utf-8", errors="replace"), spec
    if not tex:
        sys.exit(f"cascade_check: '{spec}' is not a file; pass --tex to read it from git")
    top = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True).stdout.strip()
    rel = os.path.relpath(Path(tex).resolve(), Path(top).resolve()).replace("\\", "/")
    r = subprocess.run(["git", "show", f"{spec}:{rel}"], capture_output=True, text=True, encoding="utf-8", errors="replace")
    if r.returncode != 0:
        sys.exit(f"cascade_check: git show {spec}:{rel} failed: {r.stderr.strip()}")
    return r.stdout, f"{spec}:{rel}"


def sentence_table(text: str):
    rows = []
    for s in tp.sections(text):
        if s["level"] == "appendix":
            break
        for p in tp.paragraphs(s["raw"], s["start"]):
            for st in tp.sentences(p["prose"]):
                rows.append({"section": s["title"], "line": p["line"], "text": st, "norm": " ".join(st.lower().split()),
                             "cw": tp.content_words(st)})
    ab = tp.detex(tp.extract_abstract(text))
    for st in tp.sentences(ab):
        rows.append({"section": "Abstract", "line": 0, "text": st, "norm": " ".join(st.lower().split()),
                     "cw": tp.content_words(st)})
    return rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--old", required=True)
    ap.add_argument("--new", help="new revision or file (default: the --tex file as it is in the working tree)")
    ap.add_argument("--tex")
    ap.add_argument("--jaccard", type=float, default=0.35)
    ap.add_argument("--min-shared", type=int, default=4)
    ap.add_argument("--out")
    ap.add_argument("--strict", action="store_true")
    a = ap.parse_args()
    if a.new is None:
        if not a.tex:
            ap.error("--new omitted: give --tex so the working-tree manuscript can be the new version")
        a.new = a.tex

    old_text, old_name = read_version(a.old, a.tex)
    new_text, new_name = read_version(a.new, a.tex)
    O, N = sentence_table(old_text), sentence_table(new_text)
    new_norms = {r["norm"] for r in N}
    old_norms = {r["norm"] for r in O}
    removed = [r for r in O if r["norm"] not in new_norms]
    added = [r for r in N if r["norm"] not in old_norms]
    unchanged = [r for r in N if r["norm"] in old_norms]

    pairs = []  # (old_row, new_row or None, jaccard)
    for r in removed:
        best, bj = None, 0.0
        for s in added:
            j = tp.jaccard(r["cw"], s["cw"])
            if j > bj:
                best, bj = s, j
        pairs.append((r, best if bj >= 0.3 else None, bj))

    residue, qualifier_drops, strengthened = [], [], []
    for r, s, j in pairs:
        dropped = (r["cw"] - s["cw"]) if s else r["cw"]
        for u in unchanged:
            if u["norm"] == r["norm"]:
                continue
            shared = r["cw"] & u["cw"]
            jac = tp.jaccard(r["cw"], u["cw"])
            if jac >= a.jaccard and len(shared) >= a.min_shared and len(dropped & u["cw"]) >= 2:
                residue.append((r, u, jac, sorted(dropped & u["cw"])))
        if s:
            lo, ln = r["norm"], s["norm"]
            def has(tok, txt):
                return re.search(r"(?<![a-z])" + re.escape(tok.strip()) + r"(?![a-z])", txt) is not None
            hd = [h for h in tp.HEDGES if has(h, lo) and not has(h, ln)]
            if hd:
                qualifier_drops.append((r, s, hd))
            un = [u for u in tp.UNIVERSALS if has(u, ln) and not has(u, lo)]
            if un:
                strengthened.append((r, s, un))

    lines = []
    say = lines.append
    say(f"# Cascade check — {old_name} → {new_name}")
    say("")
    head = (f"cascade_check: {len(removed)} sentence(s) removed/changed, {len(added)} added, "
            f"{len(residue)} candidate residue site(s), {len(qualifier_drops)} qualifier drop(s), "
            f"{len(strengthened)} strengthened quantifier(s)")
    say(head)
    say("")
    say("## 1. Changed sentences (old → best-matching new)")
    say("")
    say("| section, L | J | old | new |")
    say("|---|---:|---|---|")
    for r, s, j in pairs:
        say(f"| {r['section'][:22]}, L{r['line']} | {j:.2f} | {r['text'][:90]}… | {(s['text'][:90] + '…') if s else '(deleted)'} |")
    say("")
    say("## 2. Candidate residue — unchanged sentences that still carry the removed wording")
    say("")
    if residue:
        say("| removed at | still at | J | dropped words present | unchanged sentence |")
        say("|---|---|---:|---|---|")
        seen = set()
        for r, u, jac, dw in sorted(residue, key=lambda x: -x[2]):
            key = (r["norm"], u["norm"])
            if key in seen:
                continue
            seen.add(key)
            say(f"| {r['section'][:20]}, L{r['line']} | {u['section'][:20]}, L{u['line']} | {jac:.2f} | {', '.join(dw[:6])} | {u['text'][:90]}… |")
    else:
        say("None ✅")
    say("")
    say("## 3. Qualifiers dropped by the change (hedge in old, absent in new)")
    say("")
    if qualifier_drops:
        say("| section, L | dropped | old | new |")
        say("|---|---|---|---|")
        for r, s, hd in qualifier_drops:
            say(f"| {r['section'][:22]}, L{r['line']} | {', '.join(repr(h.strip()) for h in hd)} | {r['text'][:80]}… | {s['text'][:80]}… |")
    else:
        say("None ✅")
    say("")
    say("## 4. Quantifiers strengthened by the change (universal in new, absent in old)")
    say("")
    if strengthened:
        say("| section, L | introduced | old | new |")
        say("|---|---|---|---|")
        for r, s, un in strengthened:
            say(f"| {r['section'][:22]}, L{r['line']} | {', '.join(repr(u.strip()) for u in un)} | {r['text'][:80]}… | {s['text'][:80]}… |")
    else:
        say("None ✅")
    say("")
    say("Louis reads §2–§4 only; everything else in the diff is Harvey's. A residue row is a finding "
        "until the sentence is changed or a DECISIONS.md entry says why it stays.")
    report = "\n".join(lines)
    if a.out:
        Path(a.out).parent.mkdir(parents=True, exist_ok=True)
        Path(a.out).write_text(report, encoding="utf-8")
        print(head)
        print(f"report → {a.out}")
    else:
        print(report)
    sys.exit(1 if (a.strict and (residue or qualifier_drops or strengthened)) else 0)


if __name__ == "__main__":
    main()
