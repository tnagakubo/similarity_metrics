# Louis — recurring holes (consolidated 2026-10-10)

One memory directory. Earlier sessions started Claude Code from `projects/similarity-metric/` and from
`projects/similarity-metric/claude_science/`, so `memory: project` created three separate stores; all files
now live here. Start Claude Code from the repository root (`scripts/check_consistency.sh` warns otherwise).

## Cross-paper patterns (check first on every review)
- [Recurring holes](feedback_recurring_holes.md) — enumeration drift, marginal-vs-joint overclaim, reasonless ledger rejections, fake double evidence

- [Cold referee 2026-10-11 — 4 patterns](feedback_referee_20261011_patterns.md) — 定数 vs attainment / 単位なしの n 基準 / subset headline（構成上の勝ち）/ 順位の不確かさ。俺が当てたのは near-nominal だけ

## per-EM W₁ paper — structural holes found in the v4–v6 restructures
- [Enumeration drift across sections](project_enumeration_drift.md) — 「two gaps / three gaps / (i)-(iii)」が章ごとに別物。Q_procedure が宿無しになった真因
- [Restructure plan attack points](feedback_restructure_plan_attack_points.md) — plan レビューの初手4点: 未検証の語数前提 / 予算不整合 / 既決却下の再提案 / 数え直していない count
- [Robustness→method promotion & in-plan drift](feedback_method_vs_robustness_promotion.md) — 印刷済みの表の算術を「段」に格上げ / 表の担い手と散文の不一致 / 引数が出力を決めない決定関数
- [Point vs upper-CL & bridge residue](feedback_point_vs_upper_cl_and_bridge_residue.md) — application が点推定で L* 分類（Methods は upper CL）/ 決定機構削除後の残骸 grep
- [Prose vs code metric & roster subset](feedback_prose_vs_code_metric_and_roster_subset.md) — false-pooling 定義がコードと別物 / roster の部分引用 / AUC ラベル vs population 定義
- [Sim/App seam holes](feedback_sim_app_seam_holes.md) — σ=10 に years をつける / n≥100 と 5x margin の矛盾 / IQR で EM 間比較 / partner と distance のラベル混同 / near-null で upper CL
- [Abstract compression & back matter](feedback_abstract_compression_and_backmatter.md) — abstract が Prop 仮定・判定基準・body 免責を落とす / Data availability と SI ファイル実体の乖離
- [No-cut prose & sim scope leak](feedback_nocut_prose_and_sim_scope_leak.md) — uncut dendrogram 散文が cutree(k) を語る / unresolved partner を closest と呼ぶ / n=100 限定句が n=2000 に漏れる
- [Competitor-removal residue](feedback_competitor_removal_residue.md) — 削除した比較手法が支えていた主張の残存 / 単一手法で複数形一般化 / 引用元の scope caveat 消失

## per-EM W₁ paper — holes found while applying the Claude Science referee report
- [Patch without cascade](feedback_patch_without_cascade.md) — a claim fixed in one place survives in 2-4 others; grep the claim's keywords file-wide before adopting any fix.
- [Compression drops the qualifier](feedback_compression_drops_qualifier.md) — shortening an abstract/summary turns "in at least one world" into "wherever"; check the falsifying table cell.
- [Fix explanations unchecked](feedback_fix_explanations_unchecked.md) — 修正に添えた mechanism/rate/suffice 文が CSV 未検算で偽（10-12 Critical 4）。修正段落の説明文は 2 セル比で検算
- [Own fix text & marker swallow](feedback_own_fix_text_and_marker_swallow.md) — 10-12: 俺の修正 5 件が CSV と矛盾 / `% revised` 行が本文を飲む（round 3 で再発, guard G7）/ mean 一致なら CDF は必ず交差
- [Fixed-tau is not KR-circular](feedback_fixed_tau_not_kr_circular.md) — decline theta-sim because a fixed tau picks the winner; KR optimality is sup-only. Ext review 10-12 lessons
