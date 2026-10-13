---
name: feedback_evidence_over_inference
description: 知識に限界があるときは推測で進めず、論文等の外部知識（原典・DOI・page）を要求する。根拠の無い発言は [推測] と明示し、必要な出典は 🔍要根拠 として /ground で Rachel に回す。推測は原稿・CLAIMS・DECISIONS に入らない（Tak 2026-10-12）
metadata:
  type: feedback
---
**Source**: Tak 2026-10-12 10:09「システム改修」指示（SUITS.md scene 2026-10-12 10:29）。RESEARCH_FRAMEWORK.md §12 / S21。

**Tak の言葉**（verbatim）: 「知識量に限界がある場合、論文等の外部知識を要求する。推測だけで進めない。根拠が重要。」

**Why:** この lab の大きな誤りは全部「原典を読まずに推測で進めた」型だった — `Song_2025.md` の誤読と「定量手法は存在しない」（S7）、E17 の「定量ゼロ」「日本=定性」（abstract 読みの artifact、[[project_e17_3layer_positioning]]）、小宮山 Ch.4 の拡大解釈（[[feedback_komiyama_no_overreading]]）。推測は会話では自然に聞こえ、記録に残ると事実に化ける。

**How to apply:**
1. 発言は三種に分かれる — **根拠あり**（path / DOI + page / CSV 列を名指せる）、**推測**（`[推測]` を付けて言う）、**要根拠**（`🔍要根拠` → `/ground <statement>`）。分からないと言うのは許される。分かったふりは違反
2. 推測で原稿・`CLAIMS.md`・`DECISIONS.md` を進めない。推測に依存する判断は DECISIONS に「根拠待ち（🔍要根拠）」と書いて保留する
3. Rachel の順序: `knowledge/INDEX.md` → `summaries/` → **原典 PDF**（二次資料から引かない、S7）→ PubMed / Crossref → 無ければ `/request-paper`（DOI 必須、Rule 2.6）。検索は `LITERATURE_SEARCH_LOG.md` §1 に verbatim query で残す
4. Mike が定理・性質（W₁ の CLT、bootstrap の一致性、KR 双対）を述べるときは原典か自分の derivation を名指す。Louis は「出典は？」を finding として出せる
5. marker（`[推測]` `🔍要根拠`）は lab の記録にだけ残る。`scripts/ground_audit.py`（`check_consistency.sh` §7）が `paper/*.tex` と `CLAIMS.md` で見つけたら finding

関連: [[feedback_diverge_converge]]（絞るときに根拠の無い論点は原稿に入れない）、[[feedback_idea_stock]]（根拠の無いネタはストックには入れてよい）。
