---
name: project-e17-3layer-positioning
description: ICH E17 実務は EM clustering で地域グループ化するが principled 距離基準を欠く（資料自認）→ 我々の W₁ が補完
metadata:
  type: project
---

ICH E17 日本ワークショップ調査（2026-06-20 bg agent → 2026-06-21 全文精読で確定）の核心。**2度の修正を経た最終版**。

**最終結論（全文精読ベース）**: 既存実務（**日本=小宮山 3-layer / 中国=Song 2025、両方とも**）は EM の **clustering で地域をグループ化する定量手法を提示している**。よって「定量手法は存在しない」は誤り。しかし ── 既存 clustering は **(i) 地域間距離を定める principled な基準を欠き、(ii) 臨床 outcome スケールへ較正せず、(iii) 治療効果の異質性を bound しない**。

**最強の引用裏づけ（決定的）**: 小宮山 TF 報告書（`knowledge/pdfs/E17_TF_report.pdf` = JPMA データサイエンス部会 2022年度 TF2-2、2023）p.25 Figure 3-11「効果修飾因子のクラスタリングで併合解析を行うアプローチ」── Distance 軸の dendrogram で国を Pooled Regions A/B/C に。その説明末尾が自認: **「類似度を定める明確な基準がなく，検討したい因子が多いとグループ化された各グループの特徴を説明できない」**。これがそのまま我々の gap。Song 2025 (`Song_2025.pdf` p.4) も同手法（hierarchical/k-means、EM-endpoint 相関距離、≤4 クラスタ、出典 [2] CRC 本）。

**positioning**: per-EM W₁ は既存 clustering が*明示的に欠いている* principled distance（Kantorovich–Rubinstein metric）を供給 + Δ_max 臨床較正 + Proposition bound。**競合でなく、自認された空白を埋める**。clustering は EM *探索*ツールで、実 pooling 判断は依然定性的（5視点 + 3-layer + Table 4-1）。

**改訂 gap 文言**: 「EM clustering 等の探索的手法は使われるが、地域間距離の principled 基準を欠き（小宮山 TF 2023 が自認）、臨床較正・治療効果 bound もない。確立した定量的・臨床的に解釈可能な地域類似性評価法は存在しない。」

**❌ 訂正履歴**: bg agent の「日中とも定性・定量ゼロ」も、その後の「日本=定性/中国=clustering」分離も**両方誤り**（abstract/catalogue 読みの artifact）。全文精読で両国とも clustering 提示と確定。

**残確認（優先度低）**: clustering 正確手法は Song 参照 [2] Li/Binkowitz/Wang "Simultaneous Global New Drug Development: MRCTs After ICH E17" CRC Press 2021。gap claim は [2] 無しでも日本一次資料の自認引用で成立。

比較表(7軸)+ 配置: `projects/similarity-metric/ARS_PLAN_chapter_summaries.md` "Cross-cutting" 節。詳細: `knowledge/summaries/ICH_E17_JP_workshops_pooling_review.md`。関連: [[feedback_review_principles]] (P5 主張と証拠の比例)。
