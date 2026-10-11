---
name: feedback-komiyama-no-overreading
description: 小宮山 Ch.4（Komiyama et al., CRC Press, DOI 10.1201/9781003109785-4）は 1 EM 1 代表値 → 距離 → clustering（≤ 4 clusters）。RV1 だけが as written、RV2/RV3 は我々の拡張。原典 verbatim で引き、要約から引かない
metadata:
  type: feedback
---
**Source**: `projects/similarity-metric/EXISTING_METHODS_AND_NOVELTY.md`（Tak 2026-07-12「小宮山を拡大解釈しすぎないように」）、`memory/project_e17_3layer_positioning.md`、`knowledge/pdfs/Ch4_Pooling_Strategy/Ch4_Pooling_Strategy.md`。

**事実**（原典 §4.6）: EM を同定 → 各 EM の **代表値 1 つ**（平均など）→ Euclidean / Manhattan 距離（Lasso 重み）→ hierarchical / k-means clustering → ≤ 4 clusters。分布全体は比較しない。TF 報告書（JPMA 2023, p.25 Fig. 3-11）は「類似度を定める明確な基準がなく」と自認。

**我々の gap 文言**: 「既存 clustering は principled な距離基準を欠き、臨床較正・治療効果の bound もない。EM 分布全体を比較し臨床的に解釈可能な地域類似性評価法は存在しない」。「定量手法は存在しない」は **誤り**（Komiyama にも Song 2025 にもある）。

**禁止**:
- RV2 / RV3 を「小宮山の手法」と呼ぶ（我々の拡張）
- 要約ファイルから引く（`Song_2025.md` の「定量的な指標なし」は誤りで訂正済み 2026-09-27）。引くときは原典の文を page 付きで写す（`templates/summary_template.md` "Verbatim passages"）
- 原典が言っていないことを言わせる。summary には "What this paper does NOT say" を書く
