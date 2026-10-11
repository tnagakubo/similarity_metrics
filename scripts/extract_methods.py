#!/usr/bin/env python3
"""
extract_methods.py — cut the Methods section (and optionally an appendix) out of a LaTeX manuscript so that a
clean-room replicator sees ONLY what a reader of the paper would see (RESEARCH_FRAMEWORK S6 / /replicate).

Usage: python3 scripts/extract_methods.py paper.tex --out review_response/METHODS_ONLY_YYYYMMDD.tex
                                           [--section "Methods"] [--also "Appendix"] [--keep-comments]
Comments are stripped by default (they often contain reviewer notes and script names). \\input/\\include lines
are dropped. The output starts with a banner stating what the replicator may and may not read.
"""
import argparse
import re
import sys
from datetime import date
from pathlib import Path

SEC_RE = re.compile(r"^\\(section|chapter)\*?\{(.+?)\}")


def strip_comments(text: str) -> str:
    out = []
    for line in text.splitlines():
        buf, i = [], 0
        while i < len(line):
            c = line[i]
            if c == "\\" and i + 1 < len(line):
                buf.append(line[i:i + 2]); i += 2; continue
            if c == "%":
                break
            buf.append(c); i += 1
        s = "".join(buf)
        if s.strip() or not line.strip().startswith("%"):
            out.append(s)
    return "\n".join(out)


def section_blocks(text: str):
    lines = text.splitlines()
    starts = [(i, SEC_RE.match(l).group(2)) for i, l in enumerate(lines) if SEC_RE.match(l)]
    blocks = {}
    for k, (i, title) in enumerate(starts):
        j = starts[k + 1][0] if k + 1 < len(starts) else len(lines)
        blocks[title] = "\n".join(lines[i:j])
    return blocks


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tex"); ap.add_argument("--out", required=True)
    ap.add_argument("--section", default="Methods", help="section title to extract (substring match, case-insensitive)")
    ap.add_argument("--also", action="append", default=[], help="additional section titles (e.g. Appendix)")
    ap.add_argument("--keep-comments", action="store_true")
    a = ap.parse_args()
    text = Path(a.tex).read_text(encoding="utf-8")
    if not a.keep_comments:
        text = strip_comments(text)
    blocks = section_blocks(text)
    wanted = [a.section] + a.also
    picked = []
    for w in wanted:
        hits = [t for t in blocks if w.lower() in t.lower()]
        if not hits:
            print(f"extract_methods: no section matching '{w}' (available: {', '.join(blocks)})", file=sys.stderr); return 1
        for h in hits:
            picked.append(blocks[h])
    body = "\n\n".join(picked)
    body = re.sub(r"^\\(input|include)\{[^}]*\}\s*$", "", body, flags=re.M)
    banner = (f"% METHODS-ONLY EXTRACT of {Path(a.tex).name} — {date.today().isoformat()} — for clean-room replication.\n"
              f"% The replicator may read THIS FILE and the protocol's DGM table only. Not the project's R/, results/, or the rest of the paper.\n"
              f"% If something needed to implement the estimator is missing here, that is a finding about the Methods section.\n\n")
    Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    Path(a.out).write_text(banner + body + "\n", encoding="utf-8")
    print(f"extract_methods: {len(picked)} section(s), {len(body.splitlines())} lines → {a.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
