---
name: feedback_referee_20261011_patterns
description: 冷読 referee（2026-10-11）が当てた 4 つの型 — 定数 vs attainment、単位なしの n 基準、subset headline、順位の不確かさ。Louis が同じ穴を次に開けないために
metadata:
  type: feedback
---

**Source**: `projects/similarity-metric/review_response/REFEREE_20261011.md`（Major 1–5）。俺（Louis、文脈あり）が 10-11 の review で当てたのは M2(a) の near-nominal だけ。残り 4 つは文脈を持たない referee が raw から再計算して当てた。

1. **「定数が区別する」は「排他性」の言い換えに過ぎない** — 09-21 に exclusivity を潰した後、主張は「定数が elicitable」になった。だが同じ定数 L は L·W₂ にも L·(b−a)·D_KS にも乗る。区別する性質は **attainment**（sup が到達する）で、L* が「最小 slope」である根拠もそれ。**次から**: 「X だけが〜」を潰した後の言い換えに、まだ「X だけが」が残っていないか、競合に同じ性質を当てて確認する
2. **単位なしの n 基準は transfer しない** — coverage は √n·W₁/σ で決まる。「n ≥ 100」を GUSTO に持ち込む文（l.476）は、GUSTO の noncentrality を計算すれば一発で崩れる。**次から**: sample size の推奨文には必ず「何の単位の、どの大きさの差で」を要求する
3. **headline は subset から取っていないか、subset は construction で勝っていないか** — 「5 of 7」は adversarial set から、うち 3 つは競合が構成上頭打ち。全 13 cell を見れば 11/13 でもっと有利だった。**次から**: 比較の headline が全 cell の一部なら、残りの cell と、勝ちが DGM の構成から出ていないかを問う
4. **順位は点推定** — Table 5 の rank は中位で 10 位分ぶれる（patient resampling）。tie rule は null に対する検定で、ペア間の解像ではない。**次から**: 順位・ランキングの表には必ず「隣と区別できるか」を要求する

**Why**: 俺は CLAIMS と memory を読んでから攻めるので、台帳にある主張の形で原稿を読む。referee は台帳を知らないので、文をそのまま読む。両方要る。
