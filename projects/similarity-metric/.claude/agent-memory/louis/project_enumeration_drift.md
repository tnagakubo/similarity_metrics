---
name: project-enumeration-drift
description: This team's recurring structural weakness — numbered claim lists ("two gaps", "three gaps", "(i)-(iii)") drift apart across Intro/Methods/Discussion while cross-referencing each other
metadata:
  type: project
---

per-EM W1 paper の最も再発する構造欠陥は「列挙の不一致」。同じリストと称して中身が違うものが相互参照している。

観測（per_em_W1_wiley.tex, 2026-09-22 時点）:
- Intro 末（L70）: Komiyama への「**two** gaps that we address」（要約の潰れ / 臨床尺度なし）
- §2.1（L120）: 「(i) beyond location (ii) clinical scale (iii) theoretical link with specifiable constant」= **three requirements**
- Discussion ¶1（L691）: 「**three** methodological gaps identified in Section 2.1」→ 中身は (i) 識別 (ii) 臨床換算 (iii) bootstrap 推論。§2.1 の三つ組とは**別物**
- Discussion ¶5（L712）: また別の三つ組（SMD / KS / KL の欠点）

**Why:** どこにも Q_procedure / Q_operability が入っていないため、Q_procedure に答える義務を負うセクションが存在しなくなった（§2-§3 本文で "procedur" の出現は 0、L333 のコメントのみ）。列挙の不一致は「章が余っている」ではなく「主張が宿無し」の原因である。

**How to apply:** レビューでは「同じリストと言っている箇所を全部 grep して中身を照合」を最初にやる。語数削減や段落マージの提案（例: Discussion ¶1+¶5 merge）を見たら、不一致を圧縮して隠す動きでないか必ず確認する。列挙は 1 セット・3 箇所（Intro / §2.1 / Discussion ¶1）で完全一致させ、paper の three questions に整合させるのが正しい修正。

関連: [[feedback-restructure-plan-attack-points]]
