---
description: Ground a statement — when the team's knowledge runs out, Rachel fetches the external source (knowledge/ → original PDF → PubMed/Crossref → Paper Request) for a claim nobody can back; the statement stays labelled [推測] until a DOI/page is on disk, and nothing inferred enters the manuscript, CLAIMS or DECISIONS
model: sonnet
argument-hint: "<statement to ground>"
---

# Research Lab: Ground（根拠を取りに行く — RESEARCH_FRAMEWORK S21）

Tak（2026-10-12）: 「知識量に限界がある場合、論文等の外部知識を要求する。推測だけで進めない。根拠が重要。」
この lab の大きな誤りは全部「原典を読まずに推測で進めた」型だった（Song 2025 の誤読、E17「定量ゼロ」、小宮山 Ch.4 の拡大解釈）。この skill は「分からない」を言える場所で、「分かったふり」を止める場所。
Statement: $ARGUMENTS

## Execution
1. **発言者**（Harvey / Mike / 誰でも）: 根拠を欠く文を verbatim で 1 行、それが変える判断・段落を 1 行、現在の分類 — `[推測]`（自分の推論）か `🔍要根拠`（出典があるはずだが手元に無い）
2. **Rachel**: 内部を先に — `knowledge/INDEX.md` → `knowledge/summaries/` → **原典 PDF**（`knowledge/pdfs/`）。見つかれば path + verbatim passage（page）。summary だけから引かない（S7、`memory/feedback_komiyama_no_overreading.md`）
3. **Rachel**: 内部に無ければ外部 — PubMed（`mcp__claude_ai_PubMed__search_articles`）/ Crossref / WebSearch。候補は全件 DOI 付き。abstract しか読めていない候補は「候補あり・原典未読」と書く。全文が要れば `/request-paper <citation with DOI>`（hook `validate-paper-request.sh` が DOI / URL を要求する）
4. **Rachel**: `projects/{project}/LITERATURE_SEARCH_LOG.md` §1 に行（database、verbatim query、hits、included / excluded）。無ければ `templates/literature_search_log_template.md` から作る。採用した出典は §4 Over-reading guard にも 1 行（原典が**言っていない**こと）
5. **Louis**: 出典は本当にそれを言っているか — 文の射程、条件、母集団、「〜と解釈できる」と「〜と書いてある」の区別。言っていなければ finding
6. **Donna**: 結果を三値で閉じる — **GROUNDED**（path / DOI + page + quote）/ **INFERRED**（`[推測]` のまま。依存する判断があれば `DECISIONS.md` に「根拠待ち（🔍要根拠）」と書いて保留）/ **OPEN**（Paper Request 発行済み、Tak 待ち）。SUITS.md に scene（TOP）

## Rules
- INFERRED のまま原稿・`CLAIMS.md`・`DECISIONS.md` の本文を進めない。会話で推測を述べるのは可、`[推測]` を付ける
- marker `[推測]` `🔍要根拠` は lab の記録（SUITS、memo、backlog）にだけ残る。`python3 scripts/ground_audit.py <files>`（`check_consistency.sh` §7 が `paper/*.tex` と `CLAIMS.md` に対して走らせる）が見つけたら finding
- DOI の捏造は最悪の違反。見つからなければ「見つからない」と書く（Rule 2.6 の 🔍）
- 数式・性質（CLT、一致性、双対性）は原典か自分の derivation。derivation なら `/claims` の evidence に file を置く
- 「分からない」は正当な答え。自信のある推測は答えではない

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Ground — {statement の要約}

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Rachel が knowledge/ の INDEX を開き、次に PDF を開く。Louis が後ろから覗く。*

**Mike**: 「{statement}。これは `[推測]` だ — 出典を名指せない。」

**Rachel**: 「{出典 / 見つからない}。{verbatim passage（page）} です。」

**Louis**: 「原典は {射程} までしか言っていない。{over-reading があれば指摘}」

**Donna**: 「{GROUNDED / INFERRED / OPEN}。{INFERRED なら: 依存する判断 D-… は根拠待ちで止めたわ}」

---
```
