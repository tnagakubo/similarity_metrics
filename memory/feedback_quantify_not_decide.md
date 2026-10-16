---
name: feedback-quantify-not-decide
description: 論文は EM 分布の違いを定量化するだけで、併合の判定規則・partner 数・手続きは規定しない（規定できない）。判定は臨床的意味を考慮した deliberation（Tak 2026-09-25）
metadata:
  type: feedback
---
**Source**: `SUITS.md` Current Status「原則（Tak 09-25）」、`projects/similarity-metric/archive/cleanup_20261016/docs/RESTRUCTURE_v6_no_decision.md` §0–§1、archives/SUITS_20260927_130112.md。

**Tak の言葉**（2026-09-25）: 「厳密な判定方法は記載する必要がない。というか規定できない。違いを定量化して判定は臨床的な意味を考慮して行う」→（09-26）「判定の仕組みを抜いて」

**v6 で抜いたもの**: τ_clin と screening rule、§2.5 operability、適格判定・AND 規則・6 地域、anchor vs clustering、L_UB 感度分析。24 → 20 ページ。

**残す基準**: 不確かさ付きの量と、その量の読み方の補助 — W₁、Prop. 1（Δ_max = L·W₁）、推定量と bootstrap CI、所与の Δ_clin での L*、null floor（「ゼロと区別できない」の注意書き）、既存指標との比較。

**抜く基準**: 量を併合の判定・partner 数・手続きの推奨・EM や地域をまたぐ結合規則へ写すもの。

**書き方**: L* を報告し「読者は任意の L_UB と比較できる」。per-EM の bound は結合して joint の bound にならない（限界として一文、規則ではなく）。"deliberation rather than binary decisions"。

**適用**: 新しい段落・応答・supplement を提案する前に「これは量か、判定か」を問う。判定なら書かない。
