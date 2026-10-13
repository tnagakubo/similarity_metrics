#!/usr/bin/env python3
"""
texprose.py — shared LaTeX → prose helpers for the referee-grade checks
(claim_guards.py, structure_audit.py, cascade_check.py).

Pure standard library. Every function is deterministic and side-effect free.

  strip_comments(text)      unescaped % to end of line removed (line by line — never on a
                            collapsed string, where one comment would eat the whole file)
  drop_verbatim(text)       lstlisting / verbatim / comment environments removed
  body(text)                the part between \\begin{document} and \\end{document}
  extract_abstract(text)    \\abstract[..]{...} (Wiley), \\abstract{...} or abstract environment
  detex(s)                  LaTeX → prose; inline math counts as one word (" M "), display math
                            and float environments removed, \\cite/\\ref/\\label dropped
  sections(text)            [(level, title, label, start_line, end_line, raw)] for section /
                            subsection / appendix / bmsection
  floats(text)              [(env, label, start_line, end_line)] for table/figure/algorithm
  paragraphs(raw)           prose paragraphs of one section (floats excluded), with line numbers
  sentences(prose)          sentence split
  content_words(s)          lowercase alphabetic tokens ≥ 3 chars minus stop words
  jaccard(a, b)             set similarity
  words(prose)              word count (inline math = 1 word)
  numeric_tokens(prose)     numbers in prose (years in citation position excluded)
"""
import re

STOP = set("""
the a an and or of to in on for with by at from as is are was were be been being that this these those
it its their there which who whom whose what when where while than then thus so such into onto over under
between among within without across about above below each both all any some no not nor only also more most
less least very can could may might shall should will would do does did done have has had having here
we our ours us they them he she his her you your i me my one two three four five six seven eight nine ten
however therefore hence whereas although because since if unless until per via et al ie eg fig table section
""".split())

MATH_ENVS = r"equation|align|gather|multline|eqnarray|displaymath|flalign|alignat"
FLOAT_ENVS = r"table|figure|algorithm|algorithmic|tabular|tabularx|longtable|sidewaystable|sidewaysfigure"
VERB_ENVS = r"lstlisting|verbatim|comment|minted"
HEDGES = ["at least", "in at least one", "non-negligible", "only", "except", "within", "up to",
          "approximately", "provided", "conditional", "when ", "under ", "for the ", "in some",
          "some ", "can ", "may ", "could ", "in five of", "of seven", "of the seven", "mean-matched",
          "all but one", "but one", "clinically plausible", "in the configurations", "where "]
UNIVERSALS = ["wherever", "always", "in every", "every ", "all ", "never", "uniformly", "regardless",
              "across all", "in all", "any ", "universally", "without exception"]


def strip_comments(text: str) -> str:
    out = []
    for line in text.split("\n"):
        i = 0
        while True:
            j = line.find("%", i)
            if j < 0:
                break
            if j > 0 and line[j - 1] == "\\":
                i = j + 1
                continue
            line = line[:j]
            break
        out.append(line)
    return "\n".join(out)


def _drop_envs(text: str, envs: str) -> str:
    return re.sub(rf"\\begin\{{({envs})\*?\}}.*?\\end\{{\1\*?\}}", " ", text, flags=re.S)


def drop_verbatim(text: str) -> str:
    return _drop_envs(text, VERB_ENVS)


def body(text: str) -> str:
    m = re.search(r"\\begin\{document\}", text)
    start = m.end() if m else 0
    m2 = re.search(r"\\end\{document\}", text)
    end = m2.start() if m2 else len(text)
    return text[start:end]


def _balanced(text: str, start: int) -> int:
    """index just past the brace group that opens at text[start] == '{'."""
    depth = 0
    i = start
    while i < len(text):
        c = text[i]
        if c == "\\":
            i += 2
            continue
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return len(text)


def extract_abstract(text: str) -> str:
    t = strip_comments(text)
    m = re.search(r"\\abstract\*?(?:\[[^\]]*\])?\s*\{", t)
    if m:
        end = _balanced(t, m.end() - 1)
        return t[m.end():end - 1]
    m = re.search(r"\\begin\{abstract\}(.*?)\\end\{abstract\}", t, flags=re.S)
    return m.group(1) if m else ""


def detex(s: str, keep_math_token: bool = True) -> str:
    s = strip_comments(s)
    s = drop_verbatim(s)
    s = _drop_envs(s, MATH_ENVS)
    s = _drop_envs(s, FLOAT_ENVS)
    s = re.sub(r"\\\[.*?\\\]", " ", s, flags=re.S)
    s = re.sub(r"\$\$.*?\$\$", " ", s, flags=re.S)
    s = re.sub(r"(?<!\\)\$[^$]*\$", " M " if keep_math_token else " ", s)
    s = re.sub(r"\\(?:label|ref|eqref|autoref|cref|Cref|pageref|cite[a-zA-Z*]*|includegraphics|input|"
               r"bibliography|bibliographystyle|graphicspath|url|href|caption)\*?(?:\[[^\]]*\])*\{[^}]*\}", " ", s)
    s = re.sub(r"\\(?:begin|end)\{[^}]*\}(?:\{[^}]*\})?(?:\[[^\]]*\])?", " ", s)
    s = re.sub(r"\\[A-Za-z@]+\*?(?:\[[^\]]*\])?", " ", s)   # command names; brace args stay as text
    s = re.sub(r"\\[^A-Za-z]", " ", s)                      # \%, \&, \, etc.
    s = s.replace("{", " ").replace("}", " ").replace("~", " ")
    s = re.sub(r"---?", " - ", s)
    s = re.sub(r"[ \t]+", " ", s)
    return s


def sections(text: str):
    """Top-level structure of the body. Returns list of dicts with level, title, label, start, end, raw."""
    t = strip_comments(text)
    b_m = re.search(r"\\begin\{document\}", t)
    b0 = b_m.end() if b_m else 0
    e_m = re.search(r"\\end\{document\}", t)
    e0 = e_m.start() if e_m else len(t)
    pat = re.compile(r"\\(section|subsection|subsubsection|bmsection|appendix)\*?(?:\[[^\]]*\])?(?:\{)?", re.M)
    marks = []
    for m in pat.finditer(t, b0, e0):
        kind = m.group(1)
        if kind == "appendix":
            marks.append((m.start(), "appendix", "Appendix", "", m.end()))
            continue
        if not t[m.end() - 1:m.end()] == "{":
            continue
        end = _balanced(t, m.end() - 1)
        title_raw = t[m.end():end - 1]
        lab = re.search(r"\\label\{([^}]*)\}", title_raw)
        title = detex(title_raw).strip()
        # a \label right after the heading
        after = t[end:end + 200]
        lab2 = re.match(r"\s*\\label\{([^}]*)\}", after)
        label = lab.group(1) if lab else (lab2.group(1) if lab2 else "")
        level = {"section": 1, "bmsection": 1, "subsection": 2, "subsubsection": 3}[kind]
        marks.append((m.start(), level, title, label, end))
    out = []
    for i, (pos, level, title, label, hend) in enumerate(marks):
        nxt = marks[i + 1][0] if i + 1 < len(marks) else e0
        raw = t[hend:nxt]
        out.append({"level": level, "title": title, "label": label,
                    "start": t.count("\n", 0, pos) + 1, "end": t.count("\n", 0, nxt) + 1, "raw": raw})
    return out


def floats(text: str):
    t = strip_comments(text)
    out = []
    for m in re.finditer(rf"\\begin\{{(table|figure|algorithm|sidewaystable|sidewaysfigure)\*?\}}(.*?)\\end\{{\1\*?\}}",
                         t, flags=re.S):
        env, inner = m.group(1), m.group(2)
        labels = re.findall(r"\\label\{([^}]*)\}", inner)
        out.append({"env": env, "labels": labels, "start": t.count("\n", 0, m.start()) + 1,
                    "end": t.count("\n", 0, m.end()) + 1})
    return out


def paragraphs(raw: str, offset_line: int = 1):
    """Prose paragraphs (floats and display math removed) with starting line numbers."""
    t = _drop_envs(_drop_envs(drop_verbatim(raw), FLOAT_ENVS), MATH_ENVS)
    out, line = [], offset_line
    for chunk in re.split(r"\n\s*\n", t):
        n = chunk.count("\n") + 2
        prose = detex(chunk).strip()
        if len(prose.split()) >= 3:
            out.append({"line": line, "prose": prose})
        line += n
    return out


def sentences(prose: str):
    prose = re.sub(r"\s+", " ", prose).strip()
    if not prose:
        return []
    parts = re.split(r"(?<=[.!?])\s+(?=[A-Z(\"'M])", prose)
    return [p.strip() for p in parts if len(p.split()) >= 3]


def content_words(s: str):
    return {w for w in re.findall(r"[a-z][a-z\-]{2,}", s.lower()) if w not in STOP and w != "m"}


def jaccard(a, b) -> float:
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)


def words(prose: str) -> int:
    return len([w for w in re.split(r"\s+", prose.strip()) if re.search(r"[A-Za-z0-9]", w)])


YEAR_RE = re.compile(r"(?<![\d.])(?:1[89]\d{2}|20\d{2})(?![\d.])")
NUM_RE = re.compile(r"(?<![A-Za-z\d.])(?:\d{1,3}(?:,\d{3})+|\d+)(?:\.\d+)?%?|(?<![\w.])\.\d+")


def numeric_tokens(prose: str):
    toks = []
    for m in NUM_RE.finditer(prose):
        tok = m.group(0)
        if YEAR_RE.fullmatch(tok.rstrip("%")):
            continue
        toks.append(tok)
    return toks


def line_of(text: str, pos: int) -> int:
    return text.count("\n", 0, pos) + 1
