---
description: Pre-register a simulation / analysis protocol before any code runs (Phase 2 gate)
model: opus
argument-hint: "<study name>"
---

# Research Lab: Protocol（Phase 2 — 実行前の事前登録）

コードを走らせる前に「何を・なぜ・何が言えるか」を固定する。後から都合よく結果を読まないための仕組み。
Study: $ARGUMENTS

Output: `projects/{project}/PROTOCOL_{study}.md`

## Execution

1. **Harvey**: この study が支える **claim** を一文で書く。claim が書けなければ study は要らない
2. **Mike**: 設計を書く
   - 比較対象（methods / metrics）と、それぞれ「誰の手法か」（既存 vs 我々の拡張。誤引用禁止）
   - シナリオ（分布・n・EM の数）、reps、seed
   - 評価指標（AUC / ARI / coverage 等）とその定義
   - **この study が licenses する主張 / しない主張** を先に列挙
3. **Louis**: 攻撃。「結果がどう出ても claim を守れる設計か」「循環論法はないか（KR 双対性で W₁ が定義上最適になる設計は不可）」
4. **Katrina**: 出力物（CSV / figure）の名前と場所、図の規格を事前に決める
5. **Jessica**: Go / No-Go
6. **Donna**: PROTOCOL を保存し、SUITS.md に scene（TOP）。以後 protocol からの逸脱は理由付きで追記（削除はしない）

## 禁止
- θ（効果関数）を特定してしまう設計（一般性を破壊）→ `memory/project_no_effect_tracking_sim.md`
- protocol なしで結果を先に見る
