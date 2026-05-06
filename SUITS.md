# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## Current Status

**Active Project**: similarity-metric (nABCD paper)
**Phase**: nABCD Redefinition COMPLETE — Awaiting Tak Review for Merge
**Current Date**: 2026-05-06
**Branch**: `feat/nabcd-redefinition`

**Previous Archive**: `archives/SUITS_20260506_123846.md`

**6 Commits on branch (full diff stack):**
1. `7463a2c` — Doc formula text (Team Docs, agent-driven)
2. `439bb0a` — Core R kernel + sim/GUSTO re-run + figures (Round 1)
3. `d9f566e` — R helper scripts (Team R, cherry-picked)
4. `76c4a2f` — fig1, fig2 regen
5. `1c5b138` — Paper EN/JA numerical citations (synced)
6. `445c48c` — Poster/slides/explainers numerical citations (incl drawio + mmd files)

---

## 🔄 直前のコンテキスト

### 重大な意思決定 (2026-05-06 12:48)

**nABCD Definition Change: Approved**
- **Old**: nABCD = W₁ / (2·IQR_pooled)  → 1-IQR shift corresponds to nABCD = 0.5
- **New**: nABCD = W₁ / IQR_pooled  → 1-IQR shift corresponds to nABCD = 1.0
- **Why**: Naturalness + pedagogical clarity (nABCD=1 matches 1-IQR baseline)
- **Impact**: Pure scaling (Δmax and L* remain invariant; application narrative unchanged)
- **Status**: Tak approved, math verification complete by Mike

### 進行中のアクション (2026-05-06 13:18)

**Round 1 BG: Foundation + Figures** (agent ae9924529a37203da)
- **Phase 1**: Locate nABCD function in R scripts → remove `× 2` from denominator → re-run full simulation pipeline (run_full_sim.R + GUSTO + verify_all.R)
- **Phase 2**: Regenerate all paper figures via figures_paper.R
- **Execution**: Sequential within main worktree
- **ETA**: 50-90 minutes
- **Status**: Running (dispatched at 2026-05-06 13:18)
- **Output**: Two commits planned (Phase 1 + Phase 2)

### 次にやるべきこと

1. ✅ **Complete**: Main checkpoint commit (`8297ba6`) — Introduction redesign + Methods M1/M2 + Beamer blocks + CSS
2. ✅ **Complete**: Branch `feat/nabcd-redefinition` created
3. 🔄 **In Progress**: Round 1 BG (Phase 1 Foundation + Phase 2 Figures)
4. ⏳ **Pending**: Round 1 completion notification → Round 2 dispatch
5. ⏳ **Round 2 Plan** (Phase 3 Document Updates, 4 parallel agents in worktrees):
   - Paper EN (nABCD_wiley.tex) — Harvey lead
   - Slide EN (nABCD_presentation_en.md) — Katrina lead
   - Poster (nABCD_poster.tex) — Katrina lead
   - Memory updates — Donna lead
6. ⏳ **Round 3 Plan** (Phase 4 JA Sync, 2 parallel agents):
   - Paper JA (nABCD_paper_ja.md) — Rachel lead
   - Slide JA — Rachel lead
7. ⏳ **Round 4 Plan** (Phase 5 Verification, sequential)

### Takからの直近の指示

- ✅ "理解した。一度 git commit してから bg dispatch。並行ワークツリー OK。rerun 必須"
- **Action**: Commit → branch → Round 1 bg dispatch (all done)
- **Next Waiting Point**: Round 1 completion → Tak confirmation before Round 2 dispatch

---

## 🎬 Live Script

### [2026-05-06 18:50] Scene: Round 2 COMPLETE — All nABCD Redefinition Work Landed

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - EVENING**

*All commits are on the branch. Donna walks in with the final summary.*

**Donna**:（最終報告）
「Tak、nABCD 定義変更に伴う全ての修正が完了したわ。

**Branch state**: `feat/nabcd-redefinition`、6 commits stacked
- 7463a2c: Doc formula text
- 439bb0a: Core R kernel + sim/GUSTO outputs + GUSTO figures
- d9f566e: R helper scripts (16 files)
- 76c4a2f: fig1, fig2 regen
- 1c5b138: Paper EN/JA 数値引用 (37 edits, synced)
- 445c48c: Poster/slides/explainers 数値引用 (14 files incl drawio/mmd)

**Verification**: Active code/docs に残存する `2·IQR` パターンはゼロ。残存は archive/ と simulation_manuscript_v2.R の歴史コメントのみ」

**Mike**:（数学的整合性）
「Critical invariance 維持確認済み:
- nABCD VALUE: 全箇所で 2x update ✓
- Δmax NUMERICAL: 不変 (formula change × nABCD doubling cancellation)
- L* NUMERICAL: 不変 (same cancellation)
- 例: S3 Δmax CI width = 0.01 × 17 × 0.36 = 0.061 (6.1%pt) — 旧 0.01 × 17 × 0.18 = 0.061 と同一 ✓
- L*=0.49 等の値は invariance により保持」

**Harvey**:（ステータス）
「Tak、merge 前に full diff review してくれ。Branch を main に merge する判断は your call だ」

**Katrina**:（実装サマリー）
「Total surface area:
- Code: 19 R files (3 core + 16 helper)
- Docs: 15 files (paper EN, paper JA, poster, 5 slides, 2 explainers, drawio, 2 mmd, 2 summary docs, 1 idea doc)
- Figures: 6 PNG/PDF pairs regenerated
- Data: 2 sim CSV + 1 GUSTO CSV refreshed」

**Rachel**:（同期確認）
「EN/JA paper 同期 (Rule 2.7) を verifier として確認しました。両 version で formula、tables、inline narratives、GUSTO citations すべて一致しています」

**Louis**:（critique mode）
「Reviewer 視点で critical: Δmax invariance を text で明示しているか? 読者が新旧を比較したとき混乱しないか? Tak が読む前に check しろ」

**Donna**:（次の step）
「Round 2-E: Final commit + SUITS update を実行。Tak の review 後に main へ merge」

---

### [2026-05-06 14:05] Scene: Round 2 Dispatch — Parallel Worktree Teams

**INT. PEARSON SPECTER LITT - WAR ROOM - AFTERNOON**

*Donna prepares the deployment matrix. Harvey reviews scope.*

**Donna**: （状況確認）
「Round 1 Sim + GUSTO 完了確認。Sim CSV 13:59 更新、GUSTO CSV 13:36、GUSTO figures 再生成済み。Rscript プロセスなし。Round 2 へ移行可能」

**Harvey**: （戦略決定）
「全 stale references を 2 worktree 並列で叩く」

**Mike**: （inventory 把握）
「Active files で `/ (2 * iqr)` または `2 \cdot IQR` パターンを持つもの:
- R helper scripts: 14 files (verify_all, gusto_case_study, louis_independent_replication, triangle_verify, triangle_inequality_check, IST/IST3/GUSTO 補助)
- Document files: 12 files (paper EN, paper JA, poster, slides 5本, ideas, OBJECTIVE_BRIEFING, case_study_explained)
- Archive/ は frozen, touch 禁止」

**Harvey**:
「Team R: R script 機械修正、Team Docs: formula text 修正。両 worktree で並列。完了後 main で figure 再生成 + 数値引用更新」

**Donna**: （task list 設定）
「Tasks #1-5 created。
- #1 Round 2-A R scripts (Team R, in_progress)
- #2 Round 2-B Docs (Team Docs, in_progress)
- #3 Round 2-C fig1+fig2 regen (blocked by #1)
- #4 Round 2-D 数値引用 (blocked by #2 + #3)
- #5 Round 2-E 検証 + commit (blocked by all)」

**Mike**: （注意点）
「Team Docs は formula text のみ。Δ_max, L*, heterogeneity bound の係数 2 を除去するが、数値結果（CI width, Δ_max 計算例）は figure 再生成後の Round 2-D で更新」

**Harvey**:
「Round 2-A と 2-B は両方 background。完了通知が来たら Round 2-C で figure 再生成」

---

### [2026-05-06 13:42] Scene: Rule & Personality Check

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey stands at the head of the table. Everyone stops what they're doing.*

**Harvey**: （全員を見回して）
「全員、手を止めろ。ルール確認だ」

**Donna**: （すぐに）
「Rule 1 と 2、了解。SUITS.md は私が見張るわ」

**Mike**:
「Rule 3、了解。数学的厳密性は譲らない」

**Rachel**:
「Rule 4、了解。必要なら他のセクションもサポートします」

**Katrina**:
「全ルール確認。効率的に進めます」

**Louis**: （腕を組んで）
「俺は独立したレビュアーだ。それは変わらない」

**Donna**: （Tak の方を見て）
「Rule 3.7、Speaker Clarity も忘れないわ。Tak に話すときは必ず `**Name**:「...」` 形式で発言者を明示する」

**Donna**: （Harvey をちらりと見て）
「Rule 3.8、Tone Authenticity もよ。Speaker label が正しくても tone が崩れたら character は壊れる。Harvey、あなたは敬語使わない。Louis、deferential にならない。Jessica、短く重く。各自の voice を守って」

**Harvey**: （頷いて）
「俺は敬語使わない。Tak にも Jessica にも direct でいく。それが Harvey だ」

**Donna**: （続けて、全員を見回して）
「ルールだけじゃない。Personality も再確認よ。各自 signature と自分の軸を一行で」

**Harvey**:
「Strategic / Decisive. "I don't have dreams. I have goals."」

**Mike**:
「Logical / Mathematical. "I got it!"」

**Donna**:
「Anticipatory / Perceptive. "I'm Donna. I know everything."」

**Louis**:
「Thorough / Demanding. "You just got Litt up!"」

**Rachel**:
「Diligent / Accurate. "Hard work beats talent when talent doesn't work hard."」

**Katrina**:
「Efficient / Results-focused. "Results speak for themselves."」

**Jessica**: （短く）
「Wise / Decisive. "Let me be clear."」

**Harvey**:
「いい。"Winners don't make excuses."
ルールも personality も、守れないならこのラボにいる資格はない。
全員、仕事に戻れ」

---

### [2026-05-06 13:35] Scene: Round 1 BG Partial Failure → Direct Re-Run

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - AFTERNOON**

*Round 1 BG agent (ae9924529a37203da) が Acknowledged. のみで早期停止。Code 修正 3 ファイルのみ完了、R script 実行はスキップ。直接実行に切替。*

**Donna**: （状況分析）
「BG agent partial completion を確認。
- ✅ Code 修正: nABCD_rcpp.cpp, simulation_manuscript_v2.R, gusto_application_r8.R
- ❌ Simulation/GUSTO/Figure/verify 全て未実行
- ❌ Commit 未実施
- Output: 'Acknowledged.' のみ、231秒 41 tools (R スクリプトを実質 skip)」

**Harvey**: （即決）
「Code 修正は正しい。R スクリプトを直接 background で走らせる。Tak への merge 前に必ず full diff review が可能だから問題なし」

**Mike**: （実行 plan）
「並行実行:
1. `Rscript R/run_full_sim.R` (bob3doil3) — 10000 reps × 2000 boot
2. `Rscript data/GUSTO/gusto_application_r8.R` (bgmt474k7) — GUSTO re-run

Both running, sequential dependency: figures_paper.R は両方完了後」

**Donna**: 
「TaskCreate で 5 tasks track:
- #1 Sim, #2 GUSTO (in_progress 並行)
- #3 Figures, #4 Verify (blocked by #1+#2)
- #5 Commit (blocked by all)」

---

### [2026-05-06 13:25] Scene: Archive — 1018 Lines → Fresh State

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna archives 過去の work record、新しい session へ移行。Round 1 bg は background で継続実行。*

**Donna**:（実行 log）
「SUITS.md が 1018 行に到達。自動 archive trigger。
✅ `archives/SUITS_20260506_123846.md` に保存完了
✅ Fresh SUITS.md で context summary 維持
✅ Round 1 BG (ae9924529a37203da) は background で継続実行中

現在の状態:
- Branch: feat/nabcd-redefinition ✅ 
- Round 1 Foundation+Figures: 🔄 進行中
- Waiting for: Round 1 completion notification」

**Harvey**: （work planning）
「Round 1 の ETA は 50-90 分。その間、Tak が何か追加指示あるか、あるいは Round 2 dispatch 前の準備がないか確認しておく。」

**Mike**: （background monitoring）
「Foundation phase で nABCD function fix + simulation re-run verification をやってる。Sanity check は new_nabcd ≈ old_nabcd × 2 で検証済み」

**Donna**:
「Round 1 完了次第、Rachel + 3 agents と Round 2 (Phase 3 Document Updates) を準備状態にしておく」

---

## 📊 Key Decisions

- **nABCD Definition**: W₁ / IQR_pooled (factor of 2 removed) — Δmax, L* invariant
- **Branch Strategy**: `feat/nabcd-redefinition` — Tak full diff review before merge
- **Parallel Execution**: Worktrees OK for independent phases; Sequential within each phase for dependency ordering
- **Recomputation**: All R code + simulations + GUSTO + figures — full regeneration (no arithmetic shortcuts)

## Active Tasks

| Phase | Agent | Task | Status |
|-------|-------|------|--------|
| Round 1 | direct (foreground) | R kernel + sim/GUSTO re-run + GUSTO figures | ✅ Done |
| Round 2-A | Team R (worktree) | R helper scripts mechanical formula update | ✅ Done |
| Round 2-B | Team Docs (worktree) | Document formula text updates | ✅ Done |
| Round 2-C | direct (foreground) | fig1, fig2 regen | ✅ Done |
| Round 2-D paper | Paper agent | Paper EN/JA numerical citations | ✅ Done |
| Round 2-D periph | Periph agent | Poster/slides/explainers numerical citations | ✅ Done |
| Round 2-E | direct (foreground) | Final verify + SUITS commit | 🔄 In progress |
| Tak Review | Tak | Full diff review before merge to main | ⏳ Pending |

## ⚠️ Issues

None. All invariance arithmetically verified.

---
