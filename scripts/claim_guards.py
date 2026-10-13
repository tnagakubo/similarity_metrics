#!/usr/bin/env python3
"""
claim_guards.py — review findings compiled into executable, mutation-tested guards.

A referee finding about a *claim* (an overclaim, a dropped qualifier, a wrong unit) is a
class of phrasings, not one sentence. Fixing the sentence the referee quoted is not fixing
the claim. Each finding therefore becomes a guard in `projects/{project}/CLAIM_GUARDS.toml`,
evaluated on every edit, and every guard names a `known_bad` revision on which it MUST fail —
a check that cannot fail on a known-bad file is not a check (mutation testing of the gate).

Usage:
  python3 scripts/claim_guards.py projects/p/CLAIM_GUARDS.toml [--tex FILE] [--strict] [--mutation] [--quiet]

  --tex       manuscript to check (default: [meta].tex in the TOML, relative to the TOML's directory)
  --strict    exit 1 when any guard fails
  --mutation  evaluate every guard on its known_bad revision/file; a guard that PASSES there is
              vacuous → reported and exit 1 (independent of --strict)
  --quiet     summary line only

TOML schema (templates/claim_guards_template.toml):
  [meta]  tex = "paper/x.tex"
  [[guard]]
    id        = "M1-exclusivity-1"           unique
    finding   = "review_response/REFEREE_20261011.md M1"   provenance (free text)
    type      = "forbid" | "require" | "proximity" | "max_words" | "min_count"
    scope     = "prose" (default) | "abstract" | "section:<regex on title or label>"
    pattern   = regex (forbid / require / min_count); literal = true for plain text
    stem / qualifier = regexes (proximity: every sentence matching stem must match qualifier)
    limit     = integer (max_words: scope word count ≤ limit; min_count: pattern hits ≥ limit)
    known_bad = "<git rev>" | "file:<path>"   (optional but strongly recommended)
    pending   = true   (optional) an open finding — the fix is not applied yet. Reported as OPEN, not FAIL,
                so --strict does not block; --mutation still tests it. Remove the flag once it passes.
    note      = free text shown in the report

Scopes are prose: comments, listings, floats and display math are removed first.
"""
import argparse
import os
import re
import subprocess
import sys
import tomllib
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import texprose as tp  # noqa: E402


def git_show(rev: str, path: Path) -> str | None:
    try:
        top = subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True,
                             check=True).stdout.strip()
        rel = os.path.relpath(path.resolve(), Path(top).resolve()).replace("\\", "/")
        r = subprocess.run(["git", "show", f"{rev}:{rel}"], capture_output=True, text=True, check=True,
                           encoding="utf-8", errors="replace")
        return r.stdout
    except Exception:
        return None


def scoped_text(text: str, scope: str):
    """Returns (prose, line_offset_resolver) for a scope."""
    if scope == "abstract":
        return tp.detex(tp.extract_abstract(text)), lambda _pos: None
    if scope.startswith("section:"):
        pat = re.compile(scope.split(":", 1)[1], re.I)
        parts = [s for s in tp.sections(text) if pat.search(s["title"]) or pat.search(s["label"] or "")]
        if not parts:
            return "", lambda _pos: None
        raw = "\n\n".join(p["raw"] for p in parts)
        return tp.detex(raw), lambda _pos: parts[0]["start"]
    return tp.detex(tp.body(text)), None


def find_line(text: str, needle: str) -> int | None:
    """Best-effort line number of a prose hit in the raw manuscript (comments excluded)."""
    raw = tp.strip_comments(text)
    key = " ".join(needle.split())[:60]
    for probe in (key, key[:40], key[:25]):
        i = raw.find(probe)
        if i >= 0:
            return raw.count("\n", 0, i) + 1
        # tolerate LaTeX in between: try first three words
    w = key.split()
    if len(w) >= 3:
        m = re.search(r"\s+".join(re.escape(x) for x in w[:3]), raw)
        if m:
            return raw.count("\n", 0, m.start()) + 1
    return None


def evaluate(guard: dict, text: str):
    """Returns (passed: bool, detail: str)."""
    gtype = guard.get("type", "forbid")
    scope = guard.get("scope", "prose")
    prose, _ = scoped_text(text, scope)
    flags = re.I if guard.get("ignore_case", True) else 0
    if gtype in ("forbid", "require", "min_count"):
        pat = guard["pattern"]
        rx = re.compile(re.escape(pat) if guard.get("literal") else pat, flags)
        hits = [m for m in rx.finditer(prose)]
        if gtype == "forbid":
            if not hits:
                return True, f"0 hits for /{pat}/ in {scope}"
            locs = []
            for m in hits[:5]:
                snippet = prose[max(0, m.start() - 30):m.end() + 30].replace("\n", " ")
                ln = find_line(text, prose[m.start():m.end() + 20])
                locs.append(f"L{ln if ln else '?'} …{snippet.strip()}…")
            return False, f"{len(hits)} hit(s) in {scope}: " + " | ".join(locs)
        if gtype == "require":
            return (bool(hits), f"{len(hits)} hit(s) for /{pat}/ in {scope}" + ("" if hits else " — required phrase missing"))
        lim = int(guard.get("limit", 1))
        return (len(hits) >= lim, f"{len(hits)} hit(s) for /{pat}/ in {scope} (need ≥ {lim})")
    if gtype == "proximity":
        stem = re.compile(guard["stem"], flags)
        qual = re.compile(guard["qualifier"], flags)
        bad = [s for s in tp.sentences(prose) if stem.search(s) and not qual.search(s)]
        n_stem = sum(1 for s in tp.sentences(prose) if stem.search(s))
        if not bad:
            return True, f"{n_stem} sentence(s) match stem, all carry the qualifier ({scope})"
        locs = []
        for s in bad[:4]:
            ln = find_line(text, s)
            locs.append(f"L{ln if ln else '?'} '{s[:80]}…'")
        return False, f"{len(bad)} of {n_stem} stem sentence(s) lack qualifier /{guard['qualifier']}/: " + " | ".join(locs)
    if gtype == "max_words":
        n = tp.words(prose)
        lim = int(guard["limit"])
        return (n <= lim, f"{n} words in {scope} (limit {lim})")
    return False, f"unknown guard type '{gtype}'"


def load(toml_path: Path):
    with open(toml_path, "rb") as f:
        cfg = tomllib.load(f)
    guards = cfg.get("guard", [])
    ids = [g.get("id") for g in guards]
    dup = {i for i in ids if ids.count(i) > 1}
    if dup:
        sys.exit(f"claim_guards: duplicate guard id(s): {', '.join(sorted(dup))}")
    return cfg, guards


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("toml")
    ap.add_argument("--tex")
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--mutation", action="store_true")
    ap.add_argument("--quiet", action="store_true")
    a = ap.parse_args()
    toml_path = Path(a.toml)
    cfg, guards = load(toml_path)
    tex = Path(a.tex) if a.tex else toml_path.parent / cfg.get("meta", {}).get("tex", "")
    if not tex.is_file():
        sys.exit(f"claim_guards: manuscript not found: {tex}")
    text = tex.read_text(encoding="utf-8", errors="replace")

    results, fails, opens, vacuous, untested = [], [], [], [], []
    for g in guards:
        gid = g.get("id", "?")
        ok, detail = evaluate(g, text)
        results.append((gid, ok, detail, g))
        if not ok:
            # pending = true: an open finding whose fix is not yet applied. Reported as OPEN, never as FAIL,
            # so --strict (hook, CI) does not block until the fix lands; drop the flag once it passes.
            (opens if g.get("pending") else fails).append(gid)
        if a.mutation:
            kb = g.get("known_bad")
            if not kb:
                untested.append(gid)
                continue
            if kb.startswith("file:"):
                p = Path(kb[5:])
                if not p.is_absolute():
                    p = toml_path.parent / p
                bad_text = p.read_text(encoding="utf-8", errors="replace") if p.is_file() else None
            else:
                bad_text = git_show(kb, tex)
            if bad_text is None:
                untested.append(f"{gid} (known_bad '{kb}' unreadable)")
                continue
            ok_bad, _ = evaluate(g, bad_text)
            if ok_bad:
                vacuous.append(gid)

    print(f"claim_guards: {len(guards)} guards, {len(fails)} FAIL"
          + (f", {len(opens)} OPEN (pending findings)" if opens else "")
          + (f", {len(vacuous)} vacuous (pass on known_bad), {len(untested)} without known_bad" if a.mutation else "")
          + f" — {tex.as_posix()}")
    if not a.quiet:
        for gid, ok, detail, g in results:
            tag = "PASS" if ok else ("OPEN" if g.get("pending") else "FAIL")
            if ok and g.get("pending"):
                tag = "PASS (pending — drop the flag, the fix landed)"
            if a.mutation and gid in vacuous:
                tag += "/VACUOUS"
            print(f"[{tag}] {gid} — {g.get('note', g.get('finding', ''))}")
            print(f"       {detail}")
        if a.mutation and untested:
            print("  no known_bad (guard untested against a failing file): " + ", ".join(untested))
    rc = 0
    if a.strict and fails:
        rc = 1
    if a.mutation and vacuous:
        rc = 1
    sys.exit(rc)


if __name__ == "__main__":
    main()
