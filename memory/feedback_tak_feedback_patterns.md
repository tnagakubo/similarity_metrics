---
name: feedback-tak-feedback-patterns
description: Tak の原稿レビューで繰り返し出た指摘の集約。段落レビューの型・文言規則・作業順序・図表・論文の射程。提示前に Donna が該当パターンを列挙する（Pre-Review Check）
metadata:
  type: feedback
---
**Source**（repo 版、2026-10-10 復元）: `templates/review_checklist.md`、`.claude/rules/paper-writing.md`、`.claude/rules/r-code.md`、`.claude/projects/*/memory/feedback_review_comments.md`（2026-04-04）、`SUITS.md` Current Status と `archives/`（2026-08-31 / 09-25 / 09-26 / 09-27 の Tak 指示）。ローカル auto-memory 版と差があれば新しい方を両方に。

## 段落レビューの型（feedback_review_process）
- **段落単位**で提示（一文単位は不可 — 前後の文脈が見えないと判断できない）。EN が原稿
- 提示前に Harvey + Mike が P1–P5（`templates/review_checklist.md`）を通す。数値・証拠を含む段落は S 節も
- 全メンバーが役割別に発言。**Louis は全段落必須**。Jessica は key decision の前
- 修正案は **Option A（最小）/ B（構造）/ C（折衷）**、各 1–2 行で 変更内容・影響範囲・trade-off。Tak は典型的に B か C を選ぶが、議論の前提として A が要る
- 選択肢 → 選択 → 理由。いきなり結論を書かない（feedback_writing_logic_flow）
- 承認済み段落を再び触るときは再レビュー（`REVIEW_QUEUE` 台帳で状態を管理）

## 文言
- ICH E17 は **describes / notes / permits**。"recommends" "require" "mandate" は overclaim（2026-04-04）。当局名は Introduction で名指ししない
- simulation は **demonstrates / illustrates** まで。"proves" 禁止
- estimation-centered: "significant" / "non-significant" / binary な poolable 表現を避ける
- 本文で `\emph{}` を使わない。自明な数式説明は削除（feedback_paper_no_emph）
- 証拠を削ったら claim も narrow（S6 削除 → "scale, shape, skewness" を "scale and skewness" に）。証拠範囲外の moment/property を claim しない
- MRCT の基本説明は簡潔に（読者は知っている前提）

## 構成・順序
- 本体 §1–§4 → Discussion 整合 → 最後に Abstract / 略語 / Data availability（Terminal pass）。「Abstract は最終の原稿が完成してから」（2026-08-31）
- セクション単位の書き換えは C1 Cross-Section Cascade Check（旧名称・旧番号・旧数値を grep で全洗い出し）
- Section opening は high-level（C2）。具体的な数値・region ID は後続段落で

## 図表・数値
- 図: width 7"、base_size 11、白背景、greyscale `#1A1A1A`。slides 用は `_color`（`#D52B1E`）。caption は「何がプロットされているか」のみ（feedback_figure_paper_standard / feedback_caption_writing）
- 数値は CSV 等の出力から引く。手で転記しない。計算後は必ず再検証（→ `memory/feedback_calculation_verification.md`）

## 論文の射程（Tak の判断）
- 「厳密な判定方法は記載する必要がない。というか規定できない。違いを定量化して判定は臨床的な意味を考慮して行う」（2026-09-25）→ `memory/feedback_quantify_not_decide.md`
- 「論文作成の過程で検討した事項は supplement にしない」（2026-09-27）。Supplement は読者に渡す証拠だけ
- 「探すなら選り好みしない調査」（2026-09-26）→ 事前登録・全データ・全 EM・exclusion は結果非依存の理由で（`PROTOCOL_real_data_survey.md`）
- 小宮山 Ch.4 = 1 EM 1 代表値。RV2/RV3 は我々の拡張 → `memory/feedback_komiyama_no_overreading.md`
- θ を特定する効果追跡 sim はしない → `memory/project_no_effect_tracking_sim.md`
- 「まず間違い・誤りをすべて修正 → 判断のいる項目を一つずつ全員で議論して確定」（2026-09-26）。誤りの修正と判断を混ぜない
