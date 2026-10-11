---
name: feedback-restructure-plan-attack-points
description: Recurring defects in this team's restructure/compression plans — unverified length premise, budgets that do not sum, re-proposing recorded-rejected items, and counts quoted without re-measuring
metadata:
  type: feedback
---

Harvey の restructure / compression plan には毎回同じ穴が開く。レビュー時はこの 4 点を最初に当てる。

1. **前提未検証の語数目標**: 「total 11,800 → 7,600」のような目標が、検証されていない journal 制限に乗っている。`PAPER_OUTLINE_BILINGUAL.md` §9 T9 は「~12,400 prose words / SIM main-text limit **not verified**」と記録済み。Tak の指摘が「構成の無駄」＝clarity のときに length diet へ翻訳するのは範囲誤り。
2. **予算が合算しない**: セクション見出しの目標値と下位項目の合計が食い違う（例 2026-09-22 版: §2 header 1,900 に対し下位合計 2,050、§5 header 900 に対し下位合計 1,050）。さらに「keep」リストが目標語数に物理的に入らない（§4.5 400 words に 6 仕事）。
3. **既決・却下済み項目の再提案**: outline §9 の "Rejected structural proposals" と §8 の判断①〜⑤ を引かずに同じ提案を出す（例: anchor-vs-clustering を §3.3 に昇格 = 2026-08-30 案A で却下済みの、同じラベル）。再提案は可だが、**却下理由を引用して反駁**していなければ差し戻す。
4. **数え直していない count**: 「Study 1 は 3 表 63 cells」→ 実数は 28+18+42 = **88**（tab:coverage は S1 行が無い）。この team は Numbers Verification Gate を持つので、plan 内の数値も gate 対象。

**Why:** 2026-09-22 の restructure_plan_v1 レビューで 4 つ全部が同時に出た。どれも「読めば分かる」種類なので、指摘しないと Pass 1 で churn になる。

**How to apply:** plan 系のドキュメントを渡されたら、(a) 語数を自分で de-TeX して数える (b) 下位予算を足す (c) outline の decisions / rejected list を grep (d) cell 数・段落数を実カウント。この 4 手が終わるまで内容論に入らない。

関連: [[project-enumeration-drift]]
