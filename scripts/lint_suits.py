#!/usr/bin/env python3
"""
lint_suits.py — mechanical character-consistency lint for SUITS.md (Donna's linter).

Checks the newest scenes of the Live Script against CLAUDE.md Rule 3 / 3.7 / 3.8 and
.claude/rules/suits-script.md. It is deliberately *mechanical*: it cannot judge tone,
but it catches the violations that recur (last names, keigo in Harvey/Louis/Jessica
lines, speaker labels, "全部記録したわ", scene order, scene header shape).

Usage:
  python3 scripts/lint_suits.py [SUITS.md] [--scenes N] [--all] [--strict]

Exit code: 0 (advisory). With --strict, exit 1 when any warning is raised.
"""
import re
import sys
import argparse
from pathlib import Path

MEMBERS = {"Harvey", "Mike", "Donna", "Louis", "Rachel", "Katrina", "Jessica"}
ALLOWED_OTHER_SPEAKERS = {"Tak"}  # external voices use "Dr. ..." / "Reviewer N" labels (skipped)
LAST_NAMES = ["Ross", "Specter", "Paulsen", "Zane", "Bennett", "Pearson", "Litt"]
# Phrases in which a last name is legitimate (firm names, catchphrases)
LAST_NAME_ALLOW = [
    r"Pearson Specter Litt", r"PEARSON SPECTER LITT", r"Pearson Hardman", r"Pearson Darby",
    r"Specter Litt", r"Zane Specter Litt", r"Litt Wheeler Williams Bennett",
    r"Litt(?:ed)? up", r"Litt the hell up", r"Litt Up", r"got Litt", r"Robert Zane", r"Litt,? ?Wheeler",
]
# Members who must not use keigo (CLAUDE.md Rule 3.8)
NO_KEIGO = {"Harvey", "Louis", "Jessica"}
KEIGO_RE = re.compile(r"(です|ます|ません|ました|ましょう|ください|いただ|ございま|でしょうか)")
# Donna must never be a mere scribe (.claude/rules/suits-script.md)
DONNA_SCRIBE_RE = re.compile(r"(全部記録したわ|記録したわ。」\s*$|記録しておくわ。」\s*$)")

SCENE_RE = re.compile(r"^### \[(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2})\] Scene: (.*)$")
SPEAKER_RE = re.compile(r"^\*\*([^*]+)\*\*\s*[:：]")
LOCATION_RE = re.compile(r"^\*\*INT\. PEARSON SPECTER LITT - (.+?) - (DAY|NIGHT)\*\*")
KNOWN_LOCATIONS = {"HARVEY'S OFFICE", "CONFERENCE ROOM", "BULLPEN", "DONNA'S DESK",
                   "LOUIS'S OFFICE", "JESSICA'S OFFICE", "FILE ROOM", "CONFERENCE ROOM (MOCK STAGE)"}


def strip_stage_directions(text: str) -> str:
    # remove *italic stage directions* and （emotion） markers
    text = re.sub(r"\*[^*\n]+\*", " ", text)
    text = re.sub(r"（[^）]*）", " ", text)
    return text


def find_live_script(lines):
    for i, l in enumerate(lines):
        if l.startswith("## ") and "Live Script" in l:
            return i
    return None


def split_scenes(lines, start):
    scenes = []
    cur = None
    for idx in range(start, len(lines)):
        l = lines[idx]
        m = SCENE_RE.match(l)
        if m:
            if cur:
                scenes.append(cur)
            cur = {"line": idx + 1, "date": m.group(1), "time": m.group(2),
                   "title": m.group(3), "body": []}
        elif l.startswith("## ") and cur is not None:
            # next top-level section (Key Decisions etc.) ends the live script
            scenes.append(cur)
            cur = None
            break
        elif cur is not None:
            cur["body"].append((idx + 1, l))
    if cur:
        scenes.append(cur)
    return scenes


def extract_utterances(scene):
    """Return list of (speaker, start_line, text) for a scene."""
    utts = []
    speaker, start, buf = None, None, []
    for ln, l in scene["body"]:
        m = SPEAKER_RE.match(l)
        if m:
            if speaker is not None:
                utts.append((speaker, start, "\n".join(buf)))
            speaker, start, buf = m.group(1).strip(), ln, [l[m.end():]]
        elif l.strip() == "---":
            if speaker is not None:
                utts.append((speaker, start, "\n".join(buf)))
            speaker, start, buf = None, None, []
        elif speaker is not None:
            buf.append(l)
    if speaker is not None:
        utts.append((speaker, start, "\n".join(buf)))
    return utts


def lint(path: Path, n_scenes: int, check_all: bool):
    warnings = []
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    start = find_live_script(lines)
    if start is None:
        return ["SUITS.md: '## 🎬 Live Script' heading not found"], {}
    scenes = split_scenes(lines, start + 1)
    if not scenes:
        return ["SUITS.md: no scenes found under Live Script"], {}

    # 1) reverse-chronological order (newest at TOP) — check the whole file, it is cheap
    for a, b in zip(scenes, scenes[1:]):
        if (a["date"], a["time"]) < (b["date"], b["time"]):
            warnings.append(f"L{b['line']}: scene order — [{b['date']} {b['time']}] is newer than the scene above it "
                            f"[{a['date']} {a['time']}] (new scenes go at TOP)")

    window = scenes if check_all else scenes[:n_scenes]
    speaker_counts = {}
    for sc in window:
        body_text = "\n".join(l for _, l in sc["body"])
        # 2) location header
        loc = None
        for _, l in sc["body"]:
            m = LOCATION_RE.match(l.strip())
            if m:
                loc = m.group(1)
                break
        if loc is None:
            warnings.append(f"L{sc['line']}: scene '{sc['title'][:40]}' has no '**INT. PEARSON SPECTER LITT - {{LOCATION}} - DAY/NIGHT**' line")
        elif loc not in KNOWN_LOCATIONS:
            warnings.append(f"L{sc['line']}: unusual location '{loc}' (CLAUDE.md Location Options)")

        # 3) per-utterance checks
        for speaker, ln, text in extract_utterances(sc):
            single_word = re.fullmatch(r"[A-Za-z]+", speaker) is not None
            if single_word and speaker not in MEMBERS and speaker not in ALLOWED_OTHER_SPEAKERS:
                warnings.append(f"L{ln}: unknown speaker label '**{speaker}**' (members: {', '.join(sorted(MEMBERS))})")
                continue
            if speaker in MEMBERS:
                speaker_counts[speaker] = speaker_counts.get(speaker, 0) + 1
            dialogue = strip_stage_directions(text)
            # 3a) last names in dialogue
            scrub = dialogue
            for pat in LAST_NAME_ALLOW:
                scrub = re.sub(pat, " ", scrub)
            for ln_name in LAST_NAMES:
                if re.search(rf"(?<![A-Za-z]){ln_name}(?![A-Za-z])", scrub):
                    warnings.append(f"L{ln}: {speaker} uses a last name '{ln_name}' — first names only (CLAUDE.md Rule 3)")
            # 3b) keigo in Harvey / Louis / Jessica lines
            if speaker in NO_KEIGO:
                # ignore text that is an embedded quotation of someone else: 『...』 or "..."
                own = re.sub(r"『[^』]*』", " ", dialogue)
                own = re.sub(r"\"[^\"]*\"", " ", own)
                hits = KEIGO_RE.findall(own)
                if hits:
                    snippet = re.search(r".{0,18}(?:" + "|".join(sorted(set(hits))) + r").{0,10}", own)
                    warnings.append(f"L{ln}: {speaker} uses keigo ({', '.join(sorted(set(hits)))}) — Rule 3.8 canonical voice"
                                    + (f" → 「…{snippet.group(0).strip()}…」" if snippet else ""))
            # 3c) Donna as mere scribe (a quoted mention 『…』 of the phrase does not count)
            if speaker == "Donna" and DONNA_SCRIBE_RE.search(re.sub(r"『[^』]*』", " ", dialogue)):
                warnings.append(f"L{ln}: Donna only reports recording — add observation / advice / sarcasm (suits-script.md)")
            # 3d) dialogue should be inside 「」
            if speaker in MEMBERS and "「" not in text:
                warnings.append(f"L{ln}: {speaker} line without 「」 dialogue brackets")
    return warnings, speaker_counts


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("path", nargs="?", default="SUITS.md")
    ap.add_argument("--scenes", type=int, default=3, help="number of newest scenes to lint (default 3)")
    ap.add_argument("--all", action="store_true", help="lint every scene")
    ap.add_argument("--strict", action="store_true", help="exit 1 when warnings exist")
    ap.add_argument("--quiet", action="store_true", help="print nothing when clean")
    args = ap.parse_args()
    p = Path(args.path)
    if not p.exists():
        print(f"lint_suits: {p} not found", file=sys.stderr)
        return 0
    warnings, counts = lint(p, args.scenes, args.all)
    scope = "all scenes" if args.all else f"newest {args.scenes} scene(s)"
    if warnings:
        print(f"Donna: SUITS.md lint — {len(warnings)} warning(s) in {scope}:")
        for w in warnings:
            print(f"  - {w}")
    elif not args.quiet:
        print(f"Donna: SUITS.md lint — clean ({scope}).")
    if counts and not args.quiet:
        quiet_members = sorted(MEMBERS - set(counts))
        print("  speakers: " + ", ".join(f"{k} {v}" for k, v in sorted(counts.items()))
              + (f" | silent: {', '.join(quiet_members)}" if quiet_members else ""))
    return 1 if (warnings and args.strict) else 0


if __name__ == "__main__":
    sys.exit(main())
