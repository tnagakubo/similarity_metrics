---
description: Clean-room reproduction gate (Phase 3) — Mike re-runs the pipeline from a clean checkout and a second member compares every manuscript-feeding output against the canonical results
model: opus
argument-hint: "[study | all]"
---

# Research Lab: Reproduce（Phase 3 gate — 一発再現）

「一発再現・数値の traceability」を語るのではなく実行する。対象: $ARGUMENTS
Output: `projects/{project}/results/REPRODUCTION_{YYYYMMDD}.md`

## Execution
1. **Donna**: 対象スクリプトを `PROTOCOL_*.md` §7 と `results/*_PROVENANCE.md` から列挙。現 commit hash を記録
2. **Mike**: static lint — `bash scripts/check_r_reproducibility.sh <files>`。❌ が残るスクリプトは先に直す（seed 宣言、絶対パス除去、`sessionInfo()` の保存）
3. **Mike**: clean checkout で再実行 — `git worktree add ../repro-{YYYYMMDD} HEAD`（または `Agent(isolation: "worktree")`）、`Rscript R/{script}.R`。長時間なら `run_in_background` + Monitor。出力は worktree 側に残す
4. **Katrina**（verifier、producer と別人）: 再実行の CSV と canonical `results/*.csv` を列ごとに比較（行数・列名・`max |diff|`）。`.rds` は summary を再集計して比較。図はデータ列の一致で判定
5. **Louis**: 一致しない数値が原稿のどこに出るかを `results/NUMBERS_LEDGER.csv` から逆引き。許容差（例: parallel RNG 由来 1e-6）を **事前に** 決めていたか問う。説明できない差は「一致」と書かせない
6. **Donna**: `REPRODUCTION_{date}.md` に表（script | seed | run time | output | canonical | max abs diff | verdict）と環境（R version、renv.lock / sessionInfo）を保存、SUITS.md に scene

## 判定
- 全出力が許容差内 → PASS（Phase 3 gate ✅、`LAB_STATUS.md` に evidence path）
- R が無い環境では static lint まで行い、再実行は "not run" と明記する（PASS とは書かない）

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Reproduction — clean checkout から {N} 本を再実行

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

**Mike**:
「{N} 本を worktree で回しました。{M} 本は max diff {d}。{K} 本は差が出ました — {理由}」

**Katrina**:
「照合は私がやった。列ごとに見た。{verdict}」

**Louis**:
「差の出た {script} の数値は §{x} に出ている。直すまで PASS じゃない」

---
```
