---
description: Clean-room replication stage — Louis re-implements the estimator from the Methods text alone (no access to project code or results); Katrina compares the output with the canonical CSV; the report is a Phase 3/6 gate
model: opus
argument-hint: "<study> [canonical csv] [--keys scenario,n]"
---

# Research Lab: Replicate（clean-room replication — RESEARCH_FRAMEWORK S6）

「論文の Methods だけ読んで結果を再現できるか」を毎 draft で試す。方法論論文にとって最も厳しい検査。
Arguments: $ARGUMENTS　Output: `projects/{project}/results/REPLICATION_{YYYYMMDD}.md`

`/reproduce` との違い: `/reproduce` は **同じコード**を clean checkout で回す（再実行可能性）。`/replicate` は **別のコード**を Methods 本文から書く（記述の十分性と結果の独立性）。

## Execution
1. **Donna**: Methods 本文だけを切り出す — `python3 scripts/extract_methods.py projects/{p}/paper/{m}.tex --out projects/{p}/review_response/METHODS_ONLY_{YYYYMMDD}.tex`（必要なら `--also Appendix`）。protocol の §3D（DGM 表）のパスも決める
2. **Louis**（`Agent(subagent_type: "louis-replication")`、prompt には上の 2 ファイルのパス・study 名・出力 CSV の列仕様だけを渡す。**canonical CSV のパスは渡さない**）: `R/replication/{study}_louis.R` を書き、R があれば実行して `results/replication/{study}_louis.csv` を出す。曖昧さは script 冒頭の `## Ambiguities` に
3. **Katrina**（verifier）: `python3 scripts/compare_results.py <canonical.csv> results/replication/{study}_louis.csv --keys <keys> --tol <tol> --out results/REPLICATION_{YYYYMMDD}.md`。許容差は **事前に** protocol §4 か Mike が宣言した値（MC 誤差の 2 倍など）。宣言がなければ `1e-6` と記録する
4. **Mike**: 差が出た列を root-cause（実装の違いか、Methods の記述不足か、canonical のバグか）。canonical のバグなら `/verify-numbers` へ
5. **Harvey**: Methods の記述不足はそのまま段落修正の候補（Option A/B/C で Tak に）。Louis の `## Ambiguities` は全件、原稿に反映するか却下理由を `DECISIONS.md` に
6. **Donna**: SUITS.md に scene（TOP）。REPLICATION PASS が Phase 3→4、6→7 の gate evidence

## Rules
- Louis は自分の過去の replication（`louis_independent_replication.R` など）も読まない。毎回ゼロから
- 「一致した」は compare_results の PASS だけが言える。語ったら Donna が差し戻す
- R が無い環境では script を書くまでで止め、`REPLICATION_*.md` に "not run" と書く

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Clean-room replication — {study}

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - NIGHT**

*Louis が Methods の抜き刷りだけを机に置き、R を書いている。Mike は部屋に入れない。*

**Louis**:
「Methods だけで書いた。{N} 箇所、書いてないことを俺が決めた — {例}。それでも {結果}。You just got Litt up」

**Katrina**:
「照合した。{columns} の max abs diff は {d}。{verdict}」

**Mike**:
「{差の root cause}」

---
```
