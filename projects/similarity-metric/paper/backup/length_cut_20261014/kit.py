import sys, re, collections, os
sys.path.insert(0, "scripts")
import texprose as tp

def sect_words(text):
    secs = tp.sections(text)
    out = {}
    total = 0
    app_start = next((x["start"] for x in secs if x["level"] == "appendix"), 10**9)
    for i, s in enumerate(secs):
        if s["level"] != 1:
            continue
        j = i + 1
        raw = s["raw"]
        while j < len(secs) and secs[j]["level"] not in (1, "appendix"):
            raw += "\n\n" + secs[j]["raw"]
            j += 1
        w = sum(tp.words(p["prose"]) for p in tp.paragraphs(raw))
        lab = s["label"] or ""
        if lab.startswith("app:") or s["start"] >= app_start:
            continue
        t = s["title"]
        if t.startswith("Author") or t.startswith("Acknow") or t.startswith("Financ") or t.startswith("Conflict") or t.startswith("Data avail") or t.startswith("Supporting"):
            continue
        out[t[:14]] = w
        total += w
    out["TOTAL"] = total
    return out

def cites(text):
    t = "\n".join(l for l in text.split("\n") if not l.lstrip().startswith("%"))
    c = collections.Counter()
    for m in re.finditer(r"\\cite\{([^}]*)\}", t):
        for k in m.group(1).split(","):
            c[k.strip()] += 1
    return c

def numvals(text):
    t = "\n".join(l for l in text.split("\n") if not l.lstrip().startswith("%"))
    return collections.Counter(re.findall(r"\\numval\{([^}]*)\}", t))

if __name__ == "__main__":
    t = open(sys.argv[1], encoding="utf8").read()
    print(sect_words(t))
    c = cites(t)
    print("single cites:", sorted(k for k, v in c.items() if v == 1))
