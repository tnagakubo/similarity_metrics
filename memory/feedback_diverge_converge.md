---
name: feedback_diverge_converge
description: 研究としての発散（論点が広がる議論）は許容するが、論文は論点を絞る。目的（Question / Aims）と結果（Results / Claims）が一対一に対応しないものは原稿に入れない。絞って外した論点は捨てずにストックする（Tak 2026-10-12）
metadata:
  type: feedback
---
**Source**: Tak 2026-10-12 10:09「システム改修」指示（SUITS.md scene 2026-10-12 10:29）。RESEARCH_FRAMEWORK.md §12 / S22。

**Tak の言葉**（verbatim）: 「研究として、さまざまな論点に発散していくことは許容するが、論文としては論点を絞る。目的と結果が対応することが重要。」

**Why:** 構成の迷走 v3 → v6（判定機構を足して全部削った、[[feedback_quantify_not_decide]]）、Discussion の 348 語段落に第三の simulation study（S17）、どの結論も bind しない unbilled results 14 本（S19）、本文 1.7× venue — すべて、会議で発散した論点がそのまま原稿へ流れ込んだ結果。発散自体は研究に必要で、問題は**出口**が無かったこと。

**How to apply:**
1. 会議・レビュー・`/explore` では発散してよい。ただし論点の出口は三つだけ — **原稿**（Aim に答える）/ **`IDEAS_BACKLOG.md`**（別論文のネタ、`/idea`）/ **`exploratory/`**（手を動かして確かめる、`/explore`）。四つ目「とりあえず Discussion に書く」は無い
2. 原稿の Aim は `LAB_STATUS.md` の **Question / Aims** 行 — 目的（何を提示するか）の一文。Aim を支える結果は **Results that answer A1**（R1, R2, …）。Results の各小節と `CLAIMS.md` の各行は R 番号を持つ
3. `/necessity` は Aim ↔ Results の対応表を出す。Aim に答えない Results、Results の無い Aim はどちらも finding
4. 新しい段落・節を足す前に「どの Aim に答えるか」を 1 行で言う（`templates/review_checklist.md` Q 節）。言えなければ書かない
5. 絞るときに外した論点は捨てない → `/idea` でストック（[[feedback_idea_stock]]）。supplement にもしない（[[feedback_no_process_supplements]]）

**Aim は目的、方法ではない**（Tak 2026-10-12 10:46）: Donna が最初に書いた Aims は「A1 identification（Study 1）/ A2 estimation（Study 2）/ A3 calibration（GUSTO）」で、Tak に「現在の記載は方法になっている。目的は、効果修飾因子の分布の類似性を定量的に評価する指標を提示することだ」と訂正された。Aim は**何を提示するか**の一文。Study 名・推定量・データ名が出てきたらそれは Result 側（R1, R2, …）。`LAB_STATUS.md` は **Question / Aims**（目的）と **Results that answer A1**（対応する結果）の二行で持つ。

関連: [[feedback_evidence_over_inference]]（根拠の無い論点は絞る側に入る）。
