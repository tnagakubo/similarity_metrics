---
name: project_referee_grade_environment
description: 2026-10-11 — Claude Science の一回限りの referee を、ラボの常設機構（冷読 referee・所見→guard・修正の二次審査・構造診断・binding 分析・探索 sandbox）に置き換えた。何が機械化され、何が「超える」のか
metadata:
  type: project
---

**Source**: `projects/similarity-metric/claude_science/`（referee_report.md / structure_review.md / simulation_necessity.md / verify_corrections.R / neyman_smooth/、2026-09-21）、`RESEARCH_FRAMEWORK.md` §10、`DECISIONS.md` D-20261011-9。

## Claude Science が 2026-09-21 にやったこと（benchmark）
1. **冷読 + raw からの再計算**: 内部記録を知らずに原稿と repo だけを読み、`data/gusto.csv` から応用の全数値を再計算、Study 1 の表 81 セルを CSV と照合（23 セル不一致を発見）
2. **数学への攻撃**: 「bound は W₁ に特有」が偽（部分積分 → KS にも TV(τ)·D_KS、W₂ にも L·W₂）。defensible な主張（定数が elicitable）に置換
3. **解釈の検証**: null floor が permissive に働き headline（6 partners）を支えないこと、R2/R9 対比の両「similar」半分が unresolved であること
4. **自分の修正の再審査**: patch without cascade（3 箇所に残存）、compression dropped the qualifier（"wherever"、"non-negligible" 削除）
5. **所見を実行ゲートに**: `verify_corrections.R` — forbidden phrasings 8、proximity rule（class guard）、quantifier guard、「known-bad で落ちない check は check でない」
6. **構造診断**: 節ごとの語数 vs venue（2.1×）、float placement、Discussion の数値段落 = 第三の simulation study、論証の重複、Supplement 文字の欠番
7. **必要性分析**: 「消したらどの結論が落ちるか」— S3/S4/S7 は confirmatory、Discussion の「n で落ちない」は自分の CSV に反する（非ゼロ plateau）、8.6 MB の threshold sim は未報告
8. **生成的探索**: Neyman smooth test の 2 標本版を simulation + GUSTO + Quarto で一本

## ラボに常設した機構（2026-10-11）
| Claude Science | ラボの機構 | 超える点 |
|---|---|---|
| 1–3 一回の冷読 | `/referee` + `.claude/agents/referee.md`（blind list、再計算義務、固定書式、guard 案必須） | 毎 draft・同条件。tool scope で独立性を強制。structure/coverage の機械的所見と突き合わせ |
| 4 修正の再審査 | `/review-fix` + `scripts/cascade_check.py`（residue・qualifier drop・strengthened quantifier） | 毎修正で機械的に。Louis は diff と report だけ読む |
| 5 verify_corrections.R | `CLAIM_GUARDS.toml` + `scripts/claim_guards.py --mutation` + hook `check-claim-guards.sh` + CI | 所見が永続する guard に。known_bad の git rev で変異テスト、vacuous は CI が止める |
| 6 structure_review.md | `/structure` + `scripts/structure_audit.py` + `templates/venue_profiles.toml` | 毎回同じ物差し。float placement は `--strict` で CI |
| 7 simulation_necessity.md | `/necessity` + `scripts/evidence_coverage.py` + ratchet `results_unbilled` | unbilled が増えない。CLAIMS の evidence path を機械的に照合 |
| 8 neyman_smooth | `/explore` sandbox（`exploratory/{slug}/`、EXPLORATORY banner、出口は `/protocol` のみ） | 速く手を動かし、原稿へは leak しない（coverage が検出） |

**Why**: Claude Science の価値は「文脈を持たない読者が raw から再計算し、所見を check にした」こと。ラボは文脈を持ちすぎる（SUITS・memory）ので同じ穴を見落とす。機構で文脈を遮断し、所見を guard として残せば、一回の external review を常設の gate にできる。

**How to apply**: `/review` → 修正 → `/review-fix` の順を飛ばさない。referee に SUITS/CLAIMS/DECISIONS を渡さない。新しい Major は必ず `CLAIM_GUARDS.toml` に known_bad 付きで起票（起票者 Louis、検証 Katrina）。unbilled results は cite するか `exploratory/` へ。関連: [[feedback_review_recurrence_patterns]]、[[feedback_calculation_verification]]、[[feedback_proactive_review]]。
