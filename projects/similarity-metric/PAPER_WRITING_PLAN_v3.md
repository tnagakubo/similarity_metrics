# Paper Writing Plan v3.1 — Incremental Rewrite (v2-based, Path α framework)

**Date**: 2026-05-17
**From**: Donna Paulsen (Project Manager)
**To**: Harvey, Mike, Rachel, Katrina, Louis, Jessica + Tak (final approver)
**Re**: v2-based incremental rewrite for Path α (per-EM W₁) methodology

> ⚠ **Tak の指示 (2026-05-17 01:00)**: 「もとの論文 `nABCD_wiley.tex` をベースにしてほしい。おおきな構成は変わらないはず」
>
> **Approach 軌道修正**: Fresh rewrite (v3.0 plan) → **Incremental rewrite based on v2** (this v3.1 plan)
>
> **Rationale**: v2 paper の section structure (5 sections + 11 subsections) は Path α でも valid。書き換えは content の局所修正に限定。Timeline 28 days → **18-20 days** に短縮。

---

## 0. Executive Summary

**Goal**: v2 paper (`paper/nABCD_wiley.tex` + `paper/nABCD_paper_ja.md`) を **structure-preserving incremental rewrite** で Path α framework に移行し、**18-20 days** で submission-ready draft を達成する。

**Key principle**: 「構造維持、用語と数式は更新」
- Section/subsection 構造: **完全維持**
- Narrative flow: **大半維持** (8-9 割の text 流用可能)
- 用語: nABCD → per-EM W₁ (全置換)
- 数式: $\Delta_{\max} = L \times W_1$ (normalizer 削除)
- Scope: Multi-EM aggregation を out-of-scope に明示

**Output files**:
- 主原稿 EN: `paper/nABCD_wiley.tex` を **直接 edit** (rename しない、in-place transformation)
- 主原稿 JA: `paper/nABCD_paper_ja.md` を **同 session 内で sync** (Rule 2.7)
- Supplement: **新規追加** (`paper/supplement_path_alpha.tex` / `.md`)
- v2 final snapshot: **commit で保全** (revert 可能、historical reference)

---

## 1. Section-by-Section Diff Mapping

### Section structure (v2 unchanged, v3.1 maintained)

| # | Section/Subsection | v2 Line | v3.1 Change Type | Effort |
|---|---|---|---|---|
| Title | "Quantifying Effect Modifier Similarity..." | 23 | **Tweak**: nABCD-implicit phrasing 確認 (現状 ok) | XS |
| Abstract | nABCD-based | 40-41 | **Rewrite**: nABCD → per-EM W₁、IQR normalization 削除、L_clinical centrality | M |
| §1 Introduction | 7 paragraphs | 60-77 | **Mostly preserve**: §1.1-§1.6 維持、最終 proposal 段落 (line 75-76) のみ書き換え | S |
| §2 Methods | — | 80 | — | — |
| §2.1 Existing Approaches | SMD/KS/AD/KL criticism | 90-107 | **Preserve**: 完全維持 (Path α でも valid criticism) | XS |
| §2.2 nABCD Dissimilarity Index | 数式 + properties | 108-166 | **Rename + Rewrite**: → "Per-EM Wasserstein-1 Distance" / W₁ raw definition + properties (affine equivariance in units, dimensional analysis) | L |
| §2.3 Estimation | Empirical W₁ + bootstrap | 167-175 | **Mostly preserve**: bootstrap 部分維持、normalizer estimation の段落削除 | S |
| §2.4 Interpretation and Clinical Calibration | Δ_max = L × IQR × nABCD | 176-219 | **Formula simplify**: → $\Delta_{\max} = L_{\text{clinical}} \times W_1$、L_clinical specification 拡充 | M |
| §3 Simulation Study | — | 220 | — | — |
| §3.1 Simulation Design | 7 scenarios, normalizer comparison | 225-265 | **Refocus**: per-EM W₁ raw を primary、normalizer comparison は § supplement | M |
| §3.2 Results | Bias/Coverage/RMSE tables | 266-391 | **Restructure**: per-EM W₁ properties を中心に。N1-N8 results を W₁ raw lens で再 present | L |
| §4 Application: GUSTO-I MRCT | — | 392 | — | — |
| §4.1 Scenario Design + EM Selection | Anchor + EM choice | 397-418 | **Preserve**: 完全維持 (workflow は v2 と同じ) | XS |
| §4.2 Distributional Assessment: nABCD Across 15 Partners | 15-partner ranking | 419-464 | **Rename + Recalculate**: → "Per-EM W₁ Across 15 Partners"、数値を W₁ raw で出し直す | M |
| §4.3 Clinical Interpretation and Pooling Candidates | Δ_max ranking | 465-504 | **Recalculate**: $\Delta_{\max} = L \times W_1$ で再計算、partner ranking は最終結果は class-level で同じ可能性高 | M |
| §5 Discussion | Methodology positioning + limitations | 505- | **Substantial rewrite**: multi-EM out-of-scope 明示、why no normalization 言及、L_clinical の robustness 議論 | L |
| Supplement A (NEW) | Mathematical equivalence: Δ_max invariant to normalizer | — | **新規作成** | M |
| Supplement B (NEW) | Why no normalization (empirical with existing simulation) | — | **新規作成** | M |
| Supplement C (NEW) | Per-EM W₁ asymptotic normality (Task 1) | — | **新規作成** | M |
| Supplement D (NEW) | L_clinical specification literature | — | **新規作成** (Rachel) | S |

**Legend**: XS (< 0.5 day), S (0.5-1 day), M (1-2 days), L (2-3 days)

**総 effort estimate**: 14 days writing + 4-6 days review/revision = **18-20 days**

---

## 2. Phase-by-Phase Timeline (18-20 days)

### **Phase 0: Setup** (Days 1-2)

| Day | Owner | Task | Deliverable |
|---|---|---|---|
| 1 | Donna | v2 paper commit snapshot (revert anchor) + branch `feat/path-alpha-rewrite` | Git tag `v2-final-snapshot` |
| 1 | Donna | Supplement files skeleton (`supplement_path_alpha.tex` / `.md`) | Empty supplement files with section headers |
| 1-2 | Rachel | L_clinical literature search — **Round 1 (general methodology + disease examples)** completed; **Round 2 (MI domain, FTT 1994 + GUSTO 1993 verification)** in progress (background, after Donna's IST/GUSTO correction) | Supplement D draft (12 + ~5 sources) |
| 1-2 | Mike | Section §2.2 + §2.4 sub-outline (concrete diff to v2 text) | Detailed before/after text mapping |
| 2 | Katrina | Existing figures audit + new figures specification | Figures inventory: keep/modify/new list |

**CK0 (Day 2)**: Tak が Supplement D の L_clinical を承認。Mike's §2.2/§2.4 outline を承認。

---

### **Phase 1: Methods Rewrite** (Days 3-6)

| Day | Owner | Task |
|---|---|---|
| 3 | Mike | §2.2 rename + rewrite: "Per-EM Wasserstein-1 Distance" (W₁ definition 3 forms + properties + dimensional analysis) |
| 4 | Mike | §2.3 Estimation: bootstrap 部分維持 + normalizer 段落削除 |
| 5 | Mike + Rachel | §2.4 Calibration: $\Delta_{\max} = L \times W_1$ simplify + L_clinical specification |
| 6 | Mike | Supplement A: Mathematical equivalence proof (Δ_max invariant to normalizer) |

**Parallel**: Day 3-6 — Donna は EN-JA sync を section-by-section で実行 (Rule 2.7)、Rachel は References を Sommerfeld/Barrio/Panaretos 整備

**CK1 (Day 6)**: Methods §2.1-§2.4 + Supplement A を Tak 段落 review

---

### **Phase 2: Simulation + Application Update** (Days 7-12)

| Day | Owner | Task |
|---|---|---|
| 7 | Katrina + Mike | §3.1 Simulation Design refocus: per-EM W₁ raw primary、normalizer comparison は § supplement に移動 |
| 8 | Katrina | New figure 1 (per-EM W₁ behavior across scenarios) + figure 2 (bootstrap CI coverage) |
| 9 | Katrina + Mike | §3.2 Results restructure: W₁ raw bias/coverage を主軸に書き換え |
| 10 | Katrina + Mike | Supplement B: 'Why no normalization' empirical (既存 normalizer simulation を Δ_max equivalence demo として活用) |
| 11 | Katrina | §4.2 Application: per-EM W₁ recalculation across 15 partners (GUSTO-I, **Region 8 anchor** per v2 paper §4) |
| 12 | Katrina + Harvey | §4.3 Clinical interpretation: $\Delta_{\max} = L \times W_1$ で recalculate、partner ranking 更新 |

**Parallel**: Day 7-12 — Mike が Supplement C (asymptotic normality, Task 1 result) draft

**CK2 (Day 12)**: §3 Simulation + §4 Application + Supplements B/C を Tak 段落 review

---

### **Phase 3: Introduction + Discussion + Abstract** (Days 13-16)

| Day | Owner | Task |
|---|---|---|
| 13 | Harvey | §1 Introduction: 最終 proposal 段落 (v2 line 75-76) を per-EM W₁ proposal に書き換え (前段落は維持) |
| 14 | Harvey + Mike | §5 Discussion §5.1: Methodology positioning (vs SMD/KS/AD)、Path α justification |
| 15 | Harvey + Mike | §5 Discussion §5.2: Multi-EM aggregation as future work + why no normalization |
| 15 | Harvey + Louis | §5 Discussion §5.3: Limitations (L_clinical specification、heavy-tail/contamination 等) |
| 16 | Harvey + Katrina | Abstract rewrite (250 words) + Title 確認 (現 title は per-EM 提案にも整合、minor tweak 可能) |

**CK3 (Day 16)**: Introduction + Discussion + Abstract を Tak 段落 review

---

### **Phase 4: Integration + Internal Review** (Days 17-18)

| Day | Owner | Task |
|---|---|---|
| 17 | All | EN draft full read-through、section transitions の coherence check |
| 17 | Rachel | References pass: DOI verification、Sommerfeld/Barrio/Panaretos/Tipton/Vanderweele 整備 |
| 17 | Donna | EN-JA full sync (Rule 2.7)、terminology consistency (no 'nABCD' in main text) |
| 18 | Louis | `/review` 内部 critical review (reviewer level) |
| 18 | All | Proactive self-critique (per [feedback_proactive_review.md]) |

**CK4 (Day 18)**: Full integrated draft を Tak final review

---

### **Phase 5: External Review + Submission Prep** (Days 19-20)

| Day | Owner | Task |
|---|---|---|
| 19 | All | `/external-review` (expert homages) + `/simulate-qa` (Q&A simulation) |
| 19 | All | Address external comments by section |
| 20 | Donna + Rachel | JA final sync |
| 20 | Jessica | Final approval (CK5) |

**CK5 (Day 20)**: Submission-ready

---

## 3. v2 Text の Specific Preservation/Replacement Map

### §1 Introduction (Day 13)

**Preserve (paragraphs 1-6)**: lines 63-74
- MRCT motivation
- ICH E17 background
- Effect modifier definition
- Regional pooling rationale
- Quantitative methodology gap
- SMD limitation

**Replace (paragraph 7-8)**: lines 75-77
> Original (v2): "This paper addresses these gaps by proposing the *normalized Area Between Cumulative Distributions* (nABCD)..."
>
> Replacement (v3.1): "This paper addresses these gaps by proposing the Wasserstein-1 distance ($W_1$) on individual effect modifier distributions, expressed in their original measurement units, as the primary similarity metric for MRCT regional pooling. Clinical interpretation is achieved through a treatment-effect slope $L_{\text{clinical}}$ that converts $W_1$ to a clinically meaningful $\Delta_{\max}$ on the treatment effect scale. We argue, both mathematically and empirically, that within-EM normalization is redundant when clinical calibration is applied..."

### §2.1 Existing Approaches (Day 3 — preserve)

**Action**: 完全維持。SMD/KS/AD/KL criticism は Path α でも valid。

### §2.2 nABCD Index → "Per-EM Wasserstein-1 Distance" (Day 3)

**Rename**: `\subsection{The nABCD Dissimilarity Index}` → `\subsection{Per-EM Wasserstein-1 Distance}`

**Content rewrite**:
- W₁ definition: 3 equivalent forms (CDF, quantile, optimal transport)
- Dimensional analysis: $W_1$ has units of the underlying variable
- Properties: affine equivariance, scale-equivariance ($W_1(aF+b, aG+b) = |a| W_1(F,G)$)
- Removal: IQR normalization, dimensionless interpretation paragraphs
- Removal: "robust scale measure" justification
- Addition: Sommerfeld 2018 / Barrio 1999 / Panaretos 2019 references for theoretical properties

### §2.3 Estimation (Day 4)

**Preserve**: Empirical W₁ computation, percentile bootstrap CI
**Remove**: Normalizer estimation paragraph (no longer needed)

### §2.4 Calibration (Day 5)

**Simplify**: 
- Old: $\Delta_{\max} = L \times \text{IQR}_{\text{pooled}} \times \text{nABCD}$
- New: $\Delta_{\max} = L_{\text{clinical}} \times W_1$

**Add**: L_clinical specification (Rachel's Supplement D content), examples per disease area

### §3 Simulation (Days 7-9)

**Refocus**: 
- Primary outcomes: per-EM W₁ bias, coverage, RMSE
- Normalizer comparison: moved to Supplement B

**Existing simulation results repurpose**:
- N1-N8 results → per-EM W₁ validation (extract W₁ values, ignore normalization layer)
- Cross-EM CV → Supplement B (illustrate normalizer arbitrariness)
- Asymptotic normality (Task 1) → Supplement C

### §4 Application (Days 11-12)

**Preserve**: §4.1 Scenario design (anchor selection, EM choice rationale)

**Recalculate**: §4.2 と §4.3 の数値部分
- Existing GUSTO-I analysis script で per-EM W₁ を計算 (normalizer 不要)
- Partner ranking by per-EM W₁ raw
- Δ_max via L_clinical
- Tables/figures: rebuild with W₁ raw values

### §5 Discussion (Days 14-15)

**Substantial rewrite**:
- Multi-EM aggregation を future work として明示
- Why no normalization の rationale (Mike's equivalence + scientific appropriateness)
- L_clinical の robustness/limitations
- Path α の methodological positioning

---

## 4. Existing Assets Reuse (Updated)

| Asset | v3.1 Use |
|---|---|
| `paper/nABCD_wiley.tex` | **Edit in place** (v2 final snapshot は git tag で保全) |
| `paper/nABCD_paper_ja.md` | **Edit in place** (EN と同じ commit で sync) |
| `paper/nABCD_wiley.bib` | **Augment** (Sommerfeld/Barrio/Panaretos/Tipton/Vanderweele 追加) |
| N1-N8 simulation results | **Two-way use**: (a) per-EM W₁ validation in §3.2, (b) Supplement B normalizer arbitrariness demo |
| GUSTO-I analysis code (existing) | **Direct reuse** with per-EM W₁ output instead of nABCD |
| Existing figures (`figures/`) | **Audit + selective rebuild**: 60-70% reusable, rest regenerate |
| Slide assets (`figures/slide_*.pdf`) | **Untouched** (separate from paper) |

---

## 5. File Operations (Day 1)

```bash
# Day 1 setup commands (Donna executes):

# 1. v2 final snapshot
git checkout main  # or current branch
git add -A
git commit -m "v2 final snapshot before Path α rewrite"
git tag v2-final-snapshot

# 2. Branch for v3.1 rewrite
git checkout -b feat/path-alpha-rewrite

# 3. Create supplement skeleton files (empty placeholders)
touch paper/supplement_path_alpha.tex
touch paper/supplement_path_alpha_ja.md
```

→ **v2 paper file は rename しない**。`nABCD_wiley.tex` のまま in-place で update。Tak の指示 'ベースにしてほしい' に最忠実。Title が変わらないので filename も自然と継続。

---

## 6. Tak Review Checkpoints (5 → reduced)

| CK | Day | Materials | 5 Principles checklist 適用 |
|---|---|---|---|
| CK0 | 2 | L_clinical literature + Mike's outline | ✓ |
| CK1 | 6 | Methods §2.1-2.4 + Supplement A | ✓ (段落単位) |
| CK2 | 12 | §3 Simulation + §4 Application + Supplements B/C | ✓ |
| CK3 | 16 | §1 Introduction + §5 Discussion + Abstract + Title | ✓ |
| CK4 | 18 | Full integrated draft + internal review 反映 | ✓ |
| CK5 | 20 | External review 反映 + JA sync 完了 + Jessica approval | ✓ |

---

## 7. Member Responsibility Matrix

| Member | Primary | Secondary |
|---|---|---|
| **Harvey** | §1 final paragraph + §5 Discussion + Abstract/Title | All sections integration |
| **Mike** | §2.2-2.4 rewrite + Supplements A/C | §3 collaboration |
| **Rachel** | L_clinical literature (D) + References | §1 + §5 citations |
| **Katrina** | §3-4 results + figures + Supplement B (empirical) | §2 calibration examples |
| **Louis** | Phase 4 internal review + Discussion limitations | All phases reviewer attack |
| **Donna** | Coordination + EN-JA sync + SUITS.md | File ops + git management |
| **Jessica** | CK0-CK5 approval gates | Strategic decisions |

---

## 8. Risk Mitigation (Updated for Incremental Approach)

| Risk | Mitigation |
|---|---|
| §2.2 rewrite introduces inconsistency with §3-4 references | Mike's §2.2 outline first (Day 1-2), Katrina/Harvey sync references in Phase 2/3 |
| Tak の段落 review で fundamental issue が再 surface | Methodology は OBJECTIVE_BRIEFING v3 で frozen、CK0 で L_clinical を承認させて anchor 固定 |
| Δ_max recalculation で partner ranking が v2 と大きく異なる | Mike's equivalence proof で説明可能 (実際は数学的には大幅変化なし) — Discussion で transparency に記述 |
| Figures rebuild の time overrun | Katrina Day 8 で prototype、Day 9 で finalize、buffer Day 10-11 |
| EN-JA sync 遅延 | Donna が section ごと same-day sync を徹底 |
| L_clinical literature 不十分 | Rachel CK0 で fallback (illustrative L_clinical with explicit caveat) を準備 |

---

## 9. Success Criteria (Updated)

**At Day 20, the paper is "submission-ready" iff**:

- [ ] §1-§5 all rewritten per Path α (verified by diff-checking against v2)
- [ ] 4 supplements (A: equivalence, B: why no normalization, C: asymptotic normality, D: L_clinical lit) complete
- [ ] No occurrence of 'nABCD' in main text (only in v2 reference appendix if any)
- [ ] All Tak checkpoints CK0-CK5 passed
- [ ] Louis internal review addressed
- [ ] External review addressed
- [ ] All references have DOI (Rule 2.6)
- [ ] EN-JA fully synchronized (Rule 2.7)
- [ ] No `\emph{}` for emphasis (Rule per [feedback_paper_no_emph.md])
- [ ] All figures meet paper standard (width=7", base_size=11, bg=white)
- [ ] All figure captions: plotted, not interpreted (per [feedback_caption_writing.md])
- [ ] Jessica final approval at CK5

---

## Appendix A: v3.0 → v3.1 Plan Change Log

| Aspect | v3.0 (Fresh Rewrite) | v3.1 (Incremental Rewrite) |
|---|---|---|
| Approach | Empty TEX file から書き起こし | v2 `nABCD_wiley.tex` を in-place edit |
| Timeline | 28 days | **18-20 days** |
| File output | `paper/per_em_W1.tex` (NEW) | `paper/nABCD_wiley.tex` (EDITED) |
| Risk | High (text 全部新規) | Lower (8-9 割流用) |
| Reusable text | None (only references) | Most of §1, §2.1, §2.3, §4.1 + portions of others |
| Justification | nABCD framework 全廃 | Tak: 「構成は変わらないはず」 + 'normalization は局所変更' |

**v3.0 plan は historical reference として retained**。Approach 変更は科学的論理 (Tak's domain expertise: paper structure stays) と整合。

---

*"I'm Donna. I know everything." — and this plan reflects Tak's incremental-rewrite preference.*
