---
name: feedback-point-vs-upper-cl-and-bridge-residue
description: Recurring hole — application computes L*/Delta_max from point estimates while Methods prescribes reading "how large" from the upper CL; decision-machinery removal passes (V6-BRIDGE) leave threshold/admit/"decisions" residues
metadata:
  type: feedback
---

1. Methods が「差の大きさは upper confidence limit で読め」と書き（tex §2.3 null floor 段落・§4.2 末）、application（§4.4 L* 表）は点推定だけで L* > L_UB を数える。2026-09-26 監査で上限 CL にすると GUSTO age 9→2 (R5,R7)、SBP 11→7、両 EM 同時 6→1 (R5) に崩れた。
   **Why:** abstract の "small subset ... leading candidates" がこの点推定の数に乗っている。reviewer は一行で見抜く。
   **How to apply:** 数え上げ・分類を見たら、Methods がどの推定量（点/上限/下限）を処方しているか照合し、CSV から再計算して flip 数を出す（results/gusto_r8_w1_per_pair.csv: $3 age, $5 age upper, $7 SBP, $9 SBP upper）。

2. 決定機構を削る pass（V6-BRIDGE 等）の後は「threshold / admit / decisions require / identify suitable partners / exercised in the application / jointly」の残骸を grep。α=0.05 の resolved/unresolved 分類が「significance test ではない」宣言と衝突していないかも毎回確認。

関連: [[project-enumeration-drift]] / [[feedback-method-vs-robustness-promotion]]
