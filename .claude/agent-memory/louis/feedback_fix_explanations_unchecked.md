---
name: feedback_fix_explanations_unchecked
description: 修正文に添えた「メカニズム・速度・十分性」の説明文が CSV で検算されずに偽になる型（2026-10-12 residual review で 4 件 Critical）
metadata:
  type: feedback
---

Referee 指摘への修正を適用すると、チームは指摘された文の横に**説明文**を添える（coverage は X で決まる / bias は n^{-1/2} で落ちる / 一様 shift は KS 向き / GUSTO の n で足りる）。この説明文は誰も CSV と突き合わせない。2026-10-12 には 4 件とも自前の output と矛盾していた（S5 は S3 より標準化距離が大きいのに coverage が低い。bias は S1 以外 ≈1/n。Set 1 の一様 shift では KS が負けている。KS の要求 n 1,252 > 最小 partner 1,231）。

**Why:** residue check（/review-fix）は旧文言が残っていないかを見るだけで、新しく足した文が真かどうかは見ない。決定文に書いてある説明（例: 判断1「coverage は √n·W₁/σ の関数」）は、そのまま検証なしで原稿に入る。

**How to apply:** review では、修正マーカー（% Paragraph revised …）のある段落の「governed by / rate / best suited / suffice / follows from」を全部拾い、該当 CSV で 2 セルの比を取る。同じ性質を競合手法にも当てる（attainment は KS の bound も自分の class 内で達成する）。決定が要求した qualifier（例: 「5 of 10 below 2 MCSE」）が、abstract・まとめ段落・Discussion にまで届いているか grep する。[[feedback_referee_20261011_patterns]] [[feedback_compression_drops_qualifier]]
