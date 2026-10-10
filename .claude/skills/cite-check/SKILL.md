---
description: Citation integrity audit — Rachel reconciles every \cite key with the .bib (missing, unused, DOI) and verifies each cited sentence against the source's verbatim passage
model: sonnet
argument-hint: "[tex] [bib]"
---

# Research Lab: Cite Check（Rule 2.6 の active half）

引用の機械的照合（`scripts/cite_audit.py`）と、機械にできない照合（原典の文が本文の主張を支えるか）を分けて行う。
Arguments: $ARGUMENTS（省略時は `projects/{project}/paper/*.tex` と同名 `.bib`）
Output: `projects/{project}/review_response/CITATION_AUDIT_{YYYYMMDD}.md`

## Execution
1. **Rachel**: `python3 scripts/cite_audit.py <tex> <bib> --out <output>` — cited-but-missing / uncited / DOI 欠落 / 重複を表に
2. **Rachel**: Citation–claim table の各行について、`knowledge/summaries/` → `knowledge/pdfs/` の **原典**で "supports the claim?"（yes / partly / no）と verbatim passage（page）を埋める。summary からの引用は不可（`memory/feedback_komiyama_no_overreading.md`）
3. **Rachel**: DOI 欠落は PubMed MCP / Crossref で検索。見つからなければ 🔍 のまま残す（DOI を捏造しない）。techreport / book は URL・ISBN の疎通を確認
4. **Mike**: 数学的主張の引用（定理・不等式・漸近論）は原典の statement と **仮定**を照合する
5. **Harvey**: "no" / "partly" の行は本文を直すか引用を外す（Option A/B/C で Tak に）
6. **Donna**: SUITS.md に scene。全行 yes で PASS（`/submission-check` R5）

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Citation audit — {N} 引用を原典に当てる

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

**Rachel**:
「{N} 件の引用を原典で確認しました。{Y} 件は本文の主張を支えています。{P} 件は部分的で、{X} 件は原典にその記述がございません — {例}」

**Harvey**:
「{X} 件は直す。引用に言わせていないことを言わせるな」

---
```
