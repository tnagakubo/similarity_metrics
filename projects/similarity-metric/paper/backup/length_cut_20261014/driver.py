import sys, json, importlib
sys.path.insert(0, r"C:\tmp\kb")
sys.path.insert(0, "scripts")
import kit

def apply(src, dst, modules, log):
    text = open(src, encoding="utf8").read()
    base = kit.sect_words(text)
    rows = []
    for mod in modules:
        m = importlib.import_module(mod)

    from cuts1 import CUTS
    for c in CUTS:
        s = text.count(c["start"])
        if s != 1:
            print("FAIL", c["id"], "start occurs", s, c["start"][:70]); sys.exit(1)
        si = text.index(c["start"])
        ei = text.find(c["end"], si)
        if ei < 0:
            print("FAIL", c["id"], "end not found", c["end"][:70]); sys.exit(1)
        ee = ei + len(c["end"])
        old = text[si:ee]
        before = kit.sect_words(text)
        new_text = text[:si] + c["new"] + text[ee:]
        # marker before the line containing si
        ls = new_text.rfind("\n", 0, si) + 1
        if c.get("r3"):
            marker = "% Cut 2026-10-14 (D-20261014-1, needs Tak's veto): " + c["mk"] + "\n"
        else:
            marker = "%" + " Cut 2026-10-14 (D-20261014-1 " + c["id"] + ", " + c["tier"] + "): CLAIMS " + c["claims"] + "\n"
        new_text = new_text[:ls] + marker + new_text[ls:]
        # drop lines that became blank where the cut emptied a whole paragraph line
        lines = new_text.split("\n")
        out = []
        for i, l in enumerate(lines):
            if l.strip() == "" and c["new"].strip() == "" and i > 0 and lines[i - 1].startswith("% Cut 2026-10-14 (D-20261014-1 " + c["id"]):
                continue
            out.append(l)
        new_text = "\n".join(out)
        after = kit.sect_words(new_text)
        delta = {k: after[k] - before[k] for k in after}
        rows.append(dict(id=c["id"], sec=c["sec"], tier=c["tier"], r3=bool(c.get("r3")), claims=c["claims"], surv=c["surv"],
                         old_words=len(old.split()), new_words=len(c["new"].split()), delta=delta, old=old, new=c["new"], mk=c.get("mk", "")))
        text = new_text
        print("%-4s %-13s %-4s total %+d  (%s)" % (c["id"], c["sec"], c["tier"], delta["TOTAL"], {k: v for k, v in delta.items() if k != "TOTAL" and v}))
    open(dst, "w", encoding="utf8").write(text)
    json.dump(dict(base=base, final=kit.sect_words(text), rows=rows), open(log, "w", encoding="utf8"), indent=1, ensure_ascii=False)
    print("BASE ", base)
    print("FINAL", kit.sect_words(text))

if __name__ == "__main__":
    apply(sys.argv[1], sys.argv[2], sys.argv[4:], sys.argv[3])
