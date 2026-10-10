---
name: feedback-method-vs-robustness-promotion
description: Two recurring defects in this team's structure plans — promoting a re-display/robustness analysis to a named method component, and label/ownership drift inside a single plan document
metadata:
  type: feedback
---

構成案（RESTRUCTURE_v*）を読むときは、内容論の前にこの2点を当てる。

1. **Robustness analysis を method component に格上げしていないか。** v4 (2026-09-23) は S6「出力＋L_UB 感度」を六段の一段にした。だが eligibility は L* > L_UB なので、L_UB を動かす操作は印刷済みの L* 列上でカットを滑らせるだけ。チーム自身のコメントが証拠: `paper/per_em_W1_wiley.tex` L627–628「pure arithmetic on the Table 3 distances」、L633「the slack values above are exactly the critical scaling factors」。新情報のある scalar は joint critical factor ただ一つ。
   **Why:** 判断①（outline L729–730）が同じ理由（P3・「結論が脆い」という誤読を招く）で §4.4 の第三の robustness 項目を既に落としている。格上げは①を無言で開け直す。
   **How to apply:** 「新しい段/節」を見たら *その段が計算する量が既存の表から一意に決まらないか* を先に確認する。決まるなら段ではなく一文。

2. **一つの plan 文書内での label / 担い手 drift。** v4 は表で S3 =「手法+判断」・S6 =「手法→sponsor」と書きながら、30行後の §1 方針で「手法が担う S1–S6」と書く。同様に §3.1 の "scoring currency"（AUC vs ARI）と §3.2 の「二通貨」（viol_anchor vs viol_pair）が隣接節で同語別物。
   **Why:** [[project-enumeration-drift]] と同じ欠陥が、章ではなく plan 内部で起きている。放置すると procedure box / figure がどちらかの版で描かれる。
   **How to apply:** plan の表の列（担い手・居場所）と散文の主張を 1 行ずつ突き合わせる。用語は plan 全体で grep して一語一物を確認する。

3. **決定関数を名乗るなら引数が出力を決めているか。** v4 の `partners = f(data, EMs, Δ_clin, L_UB, estimand)` は α（tex L226 で free、§4.2 で 0.05）・anchor の指定・未解決時の扱いを引数に持たない。未解決の扱い次第で GUSTO の答えは 6 か 2（tex L625）に変わる。
   **How to apply:** 「関数」「手続き」「六段」等の枠組み提案には、*worked example の答えが一意に決まるか* を必ず問う。決まらないなら overclaim。

関連: [[project-enumeration-drift]] / [[feedback-restructure-plan-attack-points]]
