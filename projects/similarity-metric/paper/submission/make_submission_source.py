#!/usr/bin/env python3
"""make_submission_source.py — write the comment-free LaTeX source that goes to the journal.

The working manuscript (paper/per_em_W1_wiley.tex) carries the lab's edit history and Tak's veto markers as
% comments. Those are internal records and must not be uploaded with the source. This script is the single
writer of paper/submission/per_em_W1_wiley_submission.tex:

  * a line that is only a comment is dropped (TeX ignores it together with its line end, so nothing changes);
  * a trailing comment is cut back to a bare '%' (the '%' still swallows the line end, as before);
  * '\\%' (a literal percent sign) is left alone.

The output must typeset to the same text as the working file; `--check A.txt B.txt` compares two pdftotext dumps.

Usage (from paper/):
  python submission/make_submission_source.py per_em_W1_wiley.tex submission/per_em_W1_wiley_submission.tex
"""
import re
import sys

UNESCAPED = re.compile(r'(?<!\\)(?:\\\\)*%')


def strip(src: str) -> str:
    out = []
    for line in src.split('\n'):
        m = UNESCAPED.search(line)
        if m is None:
            out.append(line)
            continue
        cut = m.end() - 1                      # index of the '%'
        head = line[:cut]
        if head.strip() == '':                 # comment-only line
            continue
        out.append(head + '%')
    return '\n'.join(out)


def main():
    if len(sys.argv) == 4 and sys.argv[1] == '--check':
        a = open(sys.argv[2], encoding='utf-8', errors='replace').read().split()
        b = open(sys.argv[3], encoding='utf-8', errors='replace').read().split()
        if a == b:
            print('submission source: typeset text identical (%d tokens)' % len(a))
            return 0
        k = next((i for i, (x, y) in enumerate(zip(a, b)) if x != y), min(len(a), len(b)))
        print('submission source: typeset text DIFFERS at token %d: %r vs %r' % (k, a[k - 5:k + 5], b[k - 5:k + 5]))
        return 1
    src, dst = sys.argv[1], sys.argv[2]
    text = open(src, encoding='utf-8', newline='').read().replace('\r\n', '\n')
    clean = strip(text)
    assert 'veto' not in clean and 'Tak' not in clean, 'internal marker survived'
    open(dst, 'w', encoding='utf-8', newline='\n').write(clean)
    print('wrote %s (%d -> %d lines)' % (dst, text.count('\n') + 1, clean.count('\n') + 1))
    return 0


if __name__ == '__main__':
    sys.exit(main())
