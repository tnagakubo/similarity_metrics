---
name: feedback-prose-vs-code-metric-and-roster-subset
description: Recurring hole in Study 2 prose — metric described differently from the code's definition, roster subsets quoted as the whole, and AUC-based "blind/partial" labels that contradict the population-value definition
metadata:
  type: feedback
---

Study 2 の散文を査読するときは、必ず R コードと truth table（results/selection_sim_ext.log の "truth structure"）に当てる。2026-09-27 の段落レビュー (#8-#21) で3件出た。

1. **散文の metric 定義 ≠ コード。** "false-pooling rate among the k admitted" と書いているが、R/selection_simulation.R L295 は `f = ncm < k_true` = 「k 個に discordant が1つでも入る確率」。Set 4 n=100 で W1 precision 0.700（slot 単位の誤り 0.30）に対し fp 0.718。
2. **roster の一部を全体として引用。** Set 4 の discordant は6つ（T1,T2,P1,P2,S1,S2）で bulk-shift も2つあるのに、本文は "one control region" / "four discordant regions" と書く。S2 (KS 0.107) を入れると「最も KS で遠いのは W1=2.0 の region」は偽になる。
3. **AUC による操作的ラベルと population の定義の衝突。** RV1 は Set 4 sym_severity で平均が一致（population の距離 ≈ 0）なのに、AUC 0.63 で "partial, resolves real structure" と書かれている。原因は heteroscedastic な sample-mean noise。below-chance（0.445）も同じ機構。

**Why:** どれも reviewer がコードか truth table を1つ開けば落とせる。数値検証 gate（verify_study2）は数値を照合するが、定義文やカウントは照合しない。
**How to apply:** metric 名・「n 個の region」・blind/partial の主張を見たら、生成関数と truth table を開いて定義・個数・population 値を照合する。

関連: [[feedback-point-vs-upper-cl-and-bridge-residue]] / [[project-enumeration-drift]]
