---
description: Pre-register a simulation / analysis protocol (ADEMP + Monte Carlo SE + licenses/does-not-license) before any confirmatory code runs (Phase 2 gate)
model: opus
argument-hint: "<study name>"
---

# Research Lab: Protocol（Phase 2 — 実行前の事前登録）

コードを走らせる前に「何を・なぜ・何が言えるか」を固定し、**commit** する。後から都合よく結果を読まないための仕組み。
Study: $ARGUMENTS　Output: `projects/{project}/PROTOCOL_{study}.md`（template: `templates/protocol_template.md`）
手本: `projects/similarity-metric/PROTOCOL_real_data_survey.md`（honesty clause 付き）

## Execution
1. **Donna**: §0 Prior look — 同じデータ／生成機構で結果を見たか全員に問う。見ていれば何を・いつ・どのスクリプトで、と書く。見た後に決めた閾値は列挙し、primary outcome を閾値非依存にする
2. **Harvey**: §1 Claim を 1 文。`CLAIMS.md` の ID を引く（無ければ `/claims add` 候補）。claim が書けなければ study は要らない
3. **Mike**: §2 licenses / does not license（実行前に固定）、§3 ADEMP
   - **D**: 分布・パラメータ・n grid・EM 数・依存構造を表に。各シナリオが臨床的にありうる根拠。θ を特定する効果追跡は不可（`memory/project_no_effect_tracking_sim.md`）
   - **E**: estimand と真値の求め方（閉形式 / `integrate` の rel.tol / MC の $n_{\mathrm{MC}}$ と SE）
   - **M**: 各手法が誰のものか（既存 as written / 我々の拡張）。誤引用禁止
   - **P**: 性能指標の定義と **Monte Carlo SE** の式、目標 MCSE から $n_{\mathrm{sim}}$ を逆算（template の表）
   - §4 seed・parallel RNG・環境（renv.lock / sessionInfo）・失敗の扱い、§5 primary / secondary と探索的解析の区別
4. **Louis**: §6 攻撃 — 循環（KR 双対で W₁ が定義上最適か）/ cherry-picking / 「結果がどう出ても claim を守れるか」/ 多重性・非独立 / 誤読の予防。各攻撃に Mike が回答を書く
5. **Katrina**: §7 出力物（single writer のスクリプト、CSV の列定義、log、figure 規格、`SIMULATION_FINDINGS_{study}.md`、provenance）
6. **Jessica**: §8 Go / No-Go と条件
7. **Donna**: 保存して **commit**（hash を冒頭に）、`LAB_STATUS.md` artifacts 表、SUITS.md に scene（TOP）。以後の逸脱は §9 に理由付きで追記（削除しない）

## 機構
- PreToolUse hook `pre-run-protocol-check.sh` が、PROTOCOL に無い結果生成スクリプトの `Rscript` 実行を警告する
- 結果が出たら `/verify-numbers`（ledger）と `SIMULATION_FINDINGS` → `/claims check`

## 禁止
- θ（効果関数）を特定する設計 → `memory/project_no_effect_tracking_sim.md`
- protocol なしで結果を先に見る。見てしまったら §0 に書く（隠さない）
- MCSE の無い性能指標、seed の無い乱数

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Protocol — {study} を事前登録

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

**Harvey**:
「claim は一文だ。{claim}。これが書けないなら回す意味はない」

**Mike**:
「ADEMP で固めました。n_sim は {N}、coverage の MCSE が {x} 以下になる数です。licenses するのは {…}、しないのは {…}」

**Louis**:
「{attack}。結果が逆に出たらどう書く？」

**Jessica**:
「Let me be clear。Go。条件は {condition}」

---
```
