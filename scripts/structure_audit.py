#!/usr/bin/env python3
"""
structure_audit.py — structural diagnostics of a manuscript (Harvey's tool; RESEARCH_FRAMEWORK S17).

What a structural referee measures before reading for content:
  1. Word budget   prose words per top-level section against a venue profile (templates/venue_profiles.toml)
  2. Floats        every float cited before it is defined; no uncited float; no \\ref to a missing float
  3. Evidence placement   numeric density per paragraph; Introduction/Discussion paragraphs above the
                   venue's threshold are "evidence outside Results" (the diagnostic that found a third
                   simulation study living in the Discussion)
  4. Duplication   sentence pairs in different sections with high content-word overlap (an argument
                   stated twice, e.g. "the three gaps" closed in two Discussion paragraphs)
  5. Supplements   Supplement letters cited in the text vs the letter sequence and the files on disk
  6. Abstract      word count vs the venue limit

Usage:
  python3 scripts/structure_audit.py paper.tex [--venue sim] [--profiles templates/venue_profiles.toml]
                                               [--out FILE] [--strict] [--dup-jaccard 0.6]
  --strict  exit 1 on: abstract over limit, uncited float, float defined before first citation,
            \\ref to a float label that does not exist
Advisory otherwise (exit 0). Summary on line 1.
"""
import argparse
import os
import re
import statistics
import sys
import tomllib
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import texprose as tp  # noqa: E402


def role_of(title: str, roles: dict) -> str:
    for role, rx in roles.items():
        if re.search(rx, title, re.I):
            return role
    return "other"


def numeric_count(raw_paragraph: str) -> int:
    """numbers in a raw paragraph: literal numeric tokens in prose + generated \\numval{} lookups."""
    n_generated = len(re.findall(r"\\numval\{", raw_paragraph))
    prose = tp.detex(raw_paragraph)
    return len(tp.numeric_tokens(prose)) + n_generated


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tex")
    ap.add_argument("--venue", default="sim")
    ap.add_argument("--profiles", default=None)
    ap.add_argument("--out")
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--dup-jaccard", type=float, default=0.6)
    a = ap.parse_args()

    tex = Path(a.tex)
    text = tex.read_text(encoding="utf-8", errors="replace")
    prof_path = Path(a.profiles) if a.profiles else Path(__file__).resolve().parent.parent / "templates" / "venue_profiles.toml"
    with open(prof_path, "rb") as f:
        profiles = tomllib.load(f)
    if a.venue not in profiles:
        print(f"structure_audit: ⚠️ unknown venue '{a.venue}' — falling back to 'generic' (known: {', '.join(sorted(profiles))})", file=sys.stderr)
    prof = profiles.get(a.venue) or profiles["generic"]
    roles = prof.get("roles", {})
    budgets = prof.get("sections", {})
    strict_fail = []
    lines = []
    say = lines.append

    # ---- 1. word budget ------------------------------------------------------------------
    secs = tp.sections(text)
    top = [s for s in secs if s["level"] == 1 or s["level"] == "appendix"]
    # body of a top-level section = its raw + raw of its subsections until the next top-level
    rows, total = [], 0
    for i, s in enumerate(secs):
        if s["level"] != 1:
            continue
        j = i + 1
        raw = s["raw"]
        while j < len(secs) and secs[j]["level"] not in (1, "appendix"):
            raw += "\n\n" + secs[j]["raw"]
            j += 1
        role = role_of(s["title"], roles)
        w = sum(tp.words(p["prose"]) for p in tp.paragraphs(raw))
        if role not in ("backmatter",) and not (s["label"] or "").startswith("app:") and s["start"] < next(
                (x["start"] for x in secs if x["level"] == "appendix"), 10**9):
            total += w
        rows.append((s["title"], s["label"], role, w))
    say("## 1. Word budget — prose words per section (floats, captions, listings excluded; inline math = 1 word)")
    say("")
    say(f"Venue profile: **{prof.get('name', a.venue)}**")
    say("")
    say("| Section | role | words | venue-typical | ratio |")
    say("|---|---|---:|---|---:|")
    over = []
    for title, label, role, w in rows:
        if role == "backmatter" or (label or "").startswith("app:"):
            continue
        b = budgets.get(role)
        if b:
            ratio = w / b[1]
            flag = f"{ratio:.1f}×" + (" ⚠" if ratio > 1.0 else "")
            if ratio > 1.0:
                over.append((title, w, b[1]))
            say(f"| {title[:48]} | {role} | {w} | {b[0]}–{b[1]} | {flag} |")
        else:
            say(f"| {title[:48]} | {role} | {w} | — | — |")
    tb = prof.get("total")
    if tb:
        say(f"| **Total (main text)** | | **{total}** | {tb[0]}–{tb[1]} | {total / tb[1]:.1f}× |")
    say("")

    # ---- 6. abstract --------------------------------------------------------------------
    ab_words = tp.words(tp.detex(tp.extract_abstract(text)))
    ab_max = int(prof.get("abstract_max", 250))
    say(f"## 2. Abstract — {ab_words} words (limit {ab_max}) {'✅' if ab_words <= ab_max else '❌'}")
    say("")
    if ab_words > ab_max:
        strict_fail.append(f"abstract {ab_words} > {ab_max}")

    # ---- 2. floats ----------------------------------------------------------------------
    t_nc = tp.strip_comments(text)
    fl = tp.floats(text)
    float_labels = {lab: f for f in fl for lab in f["labels"]}
    refs = {}
    for m in re.finditer(r"\\(?:eq|auto|c|C|page)?ref\*?\{([^}]*)\}", t_nc):
        refs.setdefault(m.group(1), []).append(tp.line_of(t_nc, m.start()))
    say("## 3. Float placement — first citation vs definition")
    say("")
    say("| float | label | defined L | first \\ref L | drift | status |")
    say("|---|---|---:|---:|---:|---|")
    for f in fl:
        if not f["labels"]:
            say(f"| {f['env']} | (no label) | {f['start']} | — | — | ⚠ unlabeled |")
            continue
        for lab in f["labels"]:
            first = min(refs.get(lab, [10**9]))
            if first == 10**9:
                st = "❌ uncited"
                strict_fail.append(f"float {lab} uncited")
                say(f"| {f['env']} | {lab} | {f['start']} | — | — | {st} |")
            else:
                drift = first - f["start"]
                st = "✅" if drift < 0 else "❌ defined before cited"
                if drift >= 0:
                    strict_fail.append(f"float {lab} defined (L{f['start']}) before first citation (L{first})")
                say(f"| {f['env']} | {lab} | {f['start']} | {first} | {drift:+d} | {st} |")
    missing = sorted(r for r in refs if (r.startswith("tab:") or r.startswith("fig:")) and r not in float_labels)
    if missing:
        say("")
        say("❌ \\ref to float labels that do not exist: " + ", ".join(missing))
        strict_fail.append("ref to missing float: " + ", ".join(missing))
    say("")

    # ---- 3. evidence placement -----------------------------------------------------------
    thr = int(prof.get("numbers_outside_results_per_paragraph", 6))
    say(f"## 4. Evidence placement — numeric tokens per paragraph (threshold outside Results: {thr})")
    say("")
    para_rows = []
    for i, s in enumerate(secs):
        if s["level"] == "appendix":
            break
        role = role_of(s["title"], roles)
        # inherit the role of the enclosing top-level section
        if s["level"] != 1:
            k = i
            while k >= 0 and secs[k]["level"] != 1:
                k -= 1
            role = role_of(secs[k]["title"], roles) if k >= 0 else role
        raw = tp._drop_envs(tp._drop_envs(tp.drop_verbatim(s["raw"]), tp.FLOAT_ENVS), tp.MATH_ENVS)
        line = s["start"]
        for chunk in re.split(r"\n\s*\n", raw):
            n_lines = chunk.count("\n") + 2
            prose = tp.detex(chunk).strip()
            if len(prose.split()) >= 20:
                para_rows.append((role, s["title"], line, numeric_count(chunk), tp.words(prose), prose[:70]))
            line += n_lines
    outside = [r for r in para_rows if r[0] in ("introduction", "discussion") and r[3] > thr]
    counts = [r[3] for r in para_rows] or [0]
    mean = statistics.mean(counts)
    sd = statistics.pstdev(counts) if len(counts) > 1 else 0
    say(f"Paragraphs analysed: {len(para_rows)}; numeric tokens per paragraph mean {mean:.1f}, SD {sd:.1f}.")
    say("")
    if outside:
        say("Paragraphs in Introduction / Discussion carrying more numbers than the threshold (evidence outside Results?):")
        say("")
        say("| section | L | numbers | words | opens with |")
        say("|---|---:|---:|---:|---|")
        for role, title, line, n, w, snip in sorted(outside, key=lambda r: -r[3]):
            say(f"| {title[:30]} | {line} | {n} | {w} | {snip}… |")
    else:
        say("No Introduction / Discussion paragraph exceeds the threshold ✅")
    say("")
    say("Densest five paragraphs overall (for reference):")
    say("")
    say("| section | L | numbers | words |")
    say("|---|---:|---:|---:|")
    for role, title, line, n, w, snip in sorted(para_rows, key=lambda r: -r[3])[:5]:
        say(f"| {title[:30]} | {line} | {n} | {w} |")
    say("")

    # ---- 4. duplication ------------------------------------------------------------------
    say(f"## 5. Duplication — sentence pairs in different sections with content-word Jaccard ≥ {a.dup_jaccard}")
    say("")
    sent_rows = []
    for s in secs:
        if s["level"] == "appendix":
            break
        for p in tp.paragraphs(s["raw"], s["start"]):
            for st in tp.sentences(p["prose"]):
                cw = tp.content_words(st)
                if len(cw) >= 8:
                    sent_rows.append((s["title"], p["line"], st, cw))
    dups = []
    for i in range(len(sent_rows)):
        for j in range(i + 1, len(sent_rows)):
            if sent_rows[i][0] == sent_rows[j][0]:
                continue
            jac = tp.jaccard(sent_rows[i][3], sent_rows[j][3])
            if jac >= a.dup_jaccard:
                dups.append((jac, sent_rows[i], sent_rows[j]))
    dups.sort(key=lambda d: -d[0])
    if dups:
        say("| J | A (section, L) | B (section, L) | A opens with |")
        say("|---:|---|---|---|")
        for jac, x, y in dups[:20]:
            say(f"| {jac:.2f} | {x[0][:22]}, L{x[1]} | {y[0][:22]}, L{y[1]} | {x[2][:70]}… |")
        if len(dups) > 20:
            say(f"| … | {len(dups) - 20} more | | |")
    else:
        say("None ✅")
    say("")

    # ---- 5. supplements ------------------------------------------------------------------
    cited = sorted(set(re.findall(r"Supplement(?:ary)?(?:\s+(?:Material|Information))?\s+([A-Z])\b", t_nc)))
    say("## 6. Supplements — letters cited in the text vs files on disk")
    say("")
    if cited:
        seq = [chr(c) for c in range(ord("A"), ord(max(cited)) + 1)]
        gaps = [c for c in seq if c not in cited]
        say(f"Cited: {', '.join(cited)}" + (f" — gap in the sequence: {', '.join(gaps)} ⚠" if gaps else " ✅"))
    else:
        say("No supplement letters cited.")
    supp_files = sorted(p.name for p in tex.parent.glob("supplement*") if p.suffix in (".tex", ".md", ".qmd", ".pdf"))
    say(f"Files beside the manuscript: {', '.join(supp_files) if supp_files else 'none'}")
    if cited and not supp_files:
        say("⚠ supplements are cited but no supplement file sits beside the manuscript")
    say("")

    head = (f"structure_audit: {tex.name} — main text {total} words"
            + (f" ({total / tb[1]:.1f}× venue upper)" if tb else "")
            + f", abstract {ab_words}/{ab_max}, floats {len(fl)} ({sum(1 for f in strict_fail if f.startswith('float'))} placement issues), "
            + f"evidence-outside-Results paragraphs {len(outside)}, duplicate sentence pairs {len(dups)}, sections over budget {len(over)}")
    report = "\n".join([f"# Structure audit — {tex.name}", "", head, ""] + lines)
    if a.out:
        Path(a.out).parent.mkdir(parents=True, exist_ok=True)
        Path(a.out).write_text(report, encoding="utf-8")
        print(head)
        print(f"report → {a.out}")
    else:
        print(report)
    sys.exit(1 if (a.strict and strict_fail) else 0)


if __name__ == "__main__":
    main()
