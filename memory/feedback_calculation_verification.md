---
name: feedback-calculation-verification
description: 数値計算後は必ず再検証してから報告する。producer と verifier を分け、原稿の全数値を results/NUMBERS_LEDGER.csv で source に結ぶ
metadata:
  type: feedback
---
**Source**（repo 版、2026-10-10 復元）: `.claude/hooks/check-numbers-verification.sh`、`.claude/skills/verify-numbers/SKILL.md`、`SUITS.md` 2026-09-27 13:10 "Numbers Verification — Mike traces every digit"、`results/STUDY1_PROVENANCE.md`（S6/S7 の MC 真値 → 数値積分への訂正）。

**原則**: 「数値計算後は必ず再検証してから報告」。一度目の計算を信用しない。

**何が間違うか**（繰り返した型）: 閾値比較の向き（KS と W₁ の bound の順序）、boolean の反転、sort の向き、単位換算（percentage points ÷ 100）、proportion と percent の混同、旧 run の数値の残存（canonical でない `results/` の読み違い）、MC 真値の誤差（S6 12.153 → quadrature 12.160）。

**手順**:
1. 原稿の全数値を抽出: `python3 scripts/numbers_audit.py <tex>`（unsourced 一覧）
2. 各数値を `results/NUMBERS_LEDGER.csv` の 1 行に: `value,label,source_file,source_locator,verified_by,verified_date,note`
3. **four-eyes**: producer（Mike）と verifier（Katrina または Louis）を分ける。verifier は source を**再実行または再導出**し、値を照合（記憶で承認しない）
4. ⚠️ mismatch / ❓ unsourced が 1 件でもあれば "submission-ready" と言わない
5. 結果は SUITS.md に scene（検証表付き）

**丸め（2026-10-11, D-20261011-2）**: 原稿に印字する数値の丸めは decimal round-half-even に統一（`scripts/r/numbers_registry.R::.num_round_dec`、`numbers_registry.py::round_dec`）。`formatC` / `sprintf` は binary double を丸めるため 0.9425 が機械によって 0.942 / 0.943 に割れた。CSV から引ける数値は手で書かず registry（`\numval{}` / `num()`）で引く。
