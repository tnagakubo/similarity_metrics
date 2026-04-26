# §4.3 Review Kit — Clinical Interpretation and Pooling Candidates

**Prepared by:** Rachel (2026-04-20 evening)
**Purpose:** 明日のレビュー即座再開のための kit。Plan B 完了後の新 §4.3 を段落単位で verify 済み。

## 前提確認（Pre-Flight Checklist）

| 項目 | 状態 |
|------|------|
| 新 §4.3 構造（3 subsection: §4.1, §4.2, §4.3）| ✅ 確認済 |
| drafts/ と wiley.tex の同期 | ✅ 同期済 |
| Cross-references（Table/Figure/Equation） | ✅ 全 valid（`fig:gusto_calibration` の broken ref を修正済） |
| 数値一致（gusto_r8_results.csv と Table） | ✅ 確認済 |
| Citations（FTT, ICH E17, GUSTO-I） | ✅ §4.1 に既存引用、新 §4.3 body に新規引用なし |
| JA 翻訳併記 | ✅ 本 kit に併記（JA ファイルは feedback_sync_ja に従い触れない） |

## Review 構成（毎段落）

各段落について以下のフォーマットで進行：

```
[段落 N]
EN 原文: ...
JA 訳: ...

Pre-Review Check (Donna):
  - [feedback パターン該当項目]

5原則チェック (Harvey + Mike):
  - P1 / P2 / P3 / P4 / P5

各メンバー voice:
  - Harvey: 戦略・メッセージ強度
  - Mike: 方法論・数学精度
  - Rachel: 文献整合性
  - Katrina: writing clarity
  - Louis: reviewer 攻撃視点（必須）
  - Jessica: 承認視点（必要時）

修正提案 → Tak 判断
```

---

## Paragraph 1: L* 導入段落

**EN**:
> For both candidate effect modifiers, $L$ is not quantified at the planning stage, so we apply the $L^*$ reverse-calculation (equation~\ref{eq:lstar}) to determine the CATE sensitivity required for the observed distributional differences to produce clinically meaningful heterogeneity ($\Delta_{\text{clin}} = 1$\%pt and $2$\%pt on the absolute 30-day mortality scale). Table~\ref{tab:gusto_lstar_joint} presents the full results for all 15 partner regions, ranked by joint distributional similarity (combined age and SBP nABCD).

**JA 直訳**:
> 両 candidate effect modifier について、$L$ は planning stage で定量化されていないため、観察された分布差を臨床的に意味のあるヘテロ性（30日死亡率の絶対スケールで $\Delta_{\text{clin}} = 1$\%pt, $2$\%pt）に translate するために必要な CATE sensitivity を決定する目的で、$L^*$ 逆算（式~\ref{eq:lstar}）を適用する。Table~\ref{tab:gusto_lstar_joint} は全 15 パートナー地域について、joint distributional similarity（age と SBP の複合）でランク付けした完全な結果を提示する。

**Pre-Review Check 候補（Donna）**:
- 「L unknown」の主語: Drug~T か EM か明確か → Drug~T-centric logic 維持されている ✓
- "candidate effect modifier" 使用 ✓
- Threshold 表現なし ✓
- "underpowered" などの検定用語なし ✓

**Louis 予想 critique**:
- 「"joint distributional similarity" の定義は？table の "combined" カラムがない」→ rank-based ordering を明記すべき
- 「$\Delta_{\text{clin}} = 1$\%pt, $2$\%pt の choice justification は §4.1 にある、self-contained か」

---

## Paragraph 2: Table 4.3-1 + Figure 導入部

**EN**: (Table ~\ref{tab:gusto_lstar_joint} と Figure ~\ref{fig:gusto_calibration} の展示)

**JA 直訳**: （テーブル・図の Japanese キャプション対応）

**Verification:**
- Table の数値（15 行全て）: `gusto_r8_results.csv` と crosscheck 済 ✓
- Ranking の妥当性: rank_sum でソート？ 注記が曖昧 → **潜在論点**
  - row 1 (R5) の rank_sum は 7 (rank_age=1 + rank_sbp=6)
  - row 3 (R4) の rank_sum は 6 (rank_age=3 + rank_sbp=3) — R5 より小さい！
  - **これは ordering inconsistency の可能性**。nABCD_age でソートした結果を rank 列に入れている可能性

**Katrina 予想 critique**:
- 「Rank 列は何を基準に ordering？ body text は "joint distributional similarity" と言うが、実質 age nABCD ascending order」
- Caption と body のメッセージ整合を要確認

---

## Paragraph 3: R4/R6/R13 特定

**EN**:
> The joint assessment identifies three regions---R4, R6, and R13---that rank low on both candidate effect modifiers, with all four nABCD values at or below 0.050 (Table~\ref{tab:gusto_lstar_joint}, rows 3, 9, 10; Figure~\ref{fig:gusto_scatter}, lower-left quadrant). These three regions exhibit the smallest joint distributional differences from Region~8, and their required $L^*$ values (Table~\ref{tab:gusto_lstar_joint}; Figure~\ref{fig:gusto_calibration}) lie near the lower end of the range that could reasonably be considered clinically plausible for thrombolysis in AMI based on the available class evidence. Accordingly, \emph{the sponsor may reasonably prioritize R4, R6, and R13 as the leading candidates for pooling with Region~8}.

**JA 直訳**:
> Joint assessment は3つの地域—R4, R6, R13—を identify する。これらは両 candidate effect modifier で low に rank し、4 つの nABCD 値全てが 0.050 以下である（Table~\ref{tab:gusto_lstar_joint} の row 3, 9, 10; Figure~\ref{fig:gusto_scatter} の左下象限）。これら 3 地域は Region~8 との joint 分布差が最小であり、required $L^*$ 値（Table~\ref{tab:gusto_lstar_joint}; Figure~\ref{fig:gusto_calibration}）は、available class evidence に基づき AMI thrombolysis で臨床的に妥当と reasonably 考えられる範囲の下端に位置する。従って、\emph{sponsor は R4, R6, R13 を Region~8 との pooling の leading candidate として reasonably prioritize できる}。

**Pre-Review Check（Donna）**:
- 「0.050 以下」境界言及: threshold ではなく **descriptive statement** として使っている → borderline 許容？
- 「weak recommendation」形: "may reasonably prioritize" ✓
- binary 表現なし ✓

**Mike 予想 critique**:
- 「"all four nABCD values" — 2 EM × 3 regions で 6 values では？」→ **numerical error 候補**
  - 実際: age と SBP の 2 値 × R4, R6, R13 の 3 地域 = 6 値
  - 'at or below 0.050' を確認: R4 age=0.016 / R4 SBP=0.042 / R6 age=0.026 / R6 SBP=0.050 / R13 age=0.034 / R13 SBP=0.037 → **全 6 値が 0.050 以下** ✓ なので "all six" が正確

**修正候補:** "all four" → "all six" (2 EM × 3 regions = 6 nABCD 値)

---

## Paragraph 4: R2 vs R9 対比

**EN**:
> The contrast between R2 and R9 illustrates why joint assessment is indispensable. R2 ranks first on SBP similarity (smallest SBP nABCD, 0.015) but last on age (largest age nABCD, 0.061), while R9 shows the opposite: third on age but last on SBP. Pooling decisions based on a single candidate effect modifier would favor each region on different grounds, yet neither ranks favorably on both modifiers. Each has a much larger $L^*$ value on one modifier (age $L^* = 0.0047$/yr for R2; SBP $L^* = 0.0015$/mmHg for R9) that must be defended separately, whereas R4, R6, and R13 require more modest CATE sensitivities on both modifiers to produce clinically meaningful heterogeneity.

**JA 直訳**:
> R2 と R9 の対比は joint assessment がなぜ不可欠かを illustrate する。R2 は SBP 類似性で 1st（最小 SBP nABCD = 0.015）だが age で 15th（最大 age nABCD = 0.061）。R9 は逆パターンで、age で 4th、SBP で 15th。単一 candidate effect modifier に基づく pooling 判断は異なる根拠でそれぞれ favor するが、どちらも両 modifier で favor されない。各々、ある modifier で遥かに大きい $L^*$ 値（R2 は age $L^* = 0.0047$/yr、R9 は SBP $L^* = 0.0015$/mmHg）を持ち、これらは別々に defend されなければならない。一方、R4, R6, R13 は両 modifier で clinically meaningful heterogeneity を produce するためにより modest な CATE sensitivity を require する。

**Verification:**
- R2 rank on SBP: 1 (Table row 14 は rank 14、でも SBP rank は最小 0.015 なので "first on SBP" ✓)
- R9 rank on age: "third on age" — でも Table では rank 4 → **整合性要確認**
  - csv file の rank_age で R9 = 4、 body text は "third" → **off-by-one error**
- R2 age rank: "last on age (largest age nABCD, 0.061)" — でも R3 (0.076) がもっと大きい。R2 は rank 14、 R3 は rank 15 → **"last" は R3 のはず、R2 は 14th**

**Louis 予想 critique**:
- 「R9 を "third on age" と書いているが、Table では row 4。rank_age = 4。body text wrong.」
- 「R2 を "last on age" と書いているが、R3 (rank 15) が実質 last。R2 は 14th (second-to-last).」

**修正候補:**
- "R9 shows the opposite: third on age but last on SBP" → "fourth on age but last on SBP"
- "R2 ranks first on SBP similarity (smallest SBP nABCD, 0.015) but last on age (largest age nABCD, 0.061)" → "but near-last on age (second-largest, 0.061)"

---

## Paragraph 5: Framework philosophy

**EN**:
> The framework does not assert binary ``poolable'' or ``not poolable'' designations. Rather, it supplies quantitative inputs---nABCD rankings, bootstrap confidence intervals (Table~\ref{tab:gusto_nabcd}), and $L^*$ sensitivities (Table~\ref{tab:gusto_lstar_joint})---that support the sponsor's judgment in consultation with clinical and regulatory advisors. Sponsors considering partners outside the leading three (R4, R6, R13) may examine the partner-specific $L^*$ values and bootstrap CI widths to weight the precision and plausibility of pooling on each candidate effect modifier.

**JA 直訳**:
> Framework は binary の ``poolable'' / ``not poolable'' designation を assert しない。むしろ、quantitative input—nABCD ranking、bootstrap CI（Table~\ref{tab:gusto_nabcd}）、$L^*$ sensitivity（Table~\ref{tab:gusto_lstar_joint}）—を供給し、sponsor が clinical・regulatory advisor と consultation しながら判断する際の support とする。Leading 3（R4, R6, R13）以外のパートナーを検討する sponsor は、partner-specific $L^*$ 値と bootstrap CI 幅を examine して、各 candidate effect modifier での pooling の precision と plausibility を weight できる。

**Pre-Review Check（Donna）**:
- Estimation-centered ✓
- Weak recommendation ✓
- binary 表現禁止 → 明示的に否定している ✓

**Jessica 予想 critique**:
- 「ICH E17 への参照が弱い。"consultation with clinical and regulatory advisors" に続けて E17 principle との整合を明記すべきか」

---

## Paragraph 6: Limitations（4 items）

全て既存のまま保持。新 §4.3 で新たな limitation 追加なし。

**Rachel 予想 critique**:
- Limitation 3「CATE sensitivity unknown a priori」は §4.3 body の内容と重複。 Limitation は body で述べられていない追加の留意点に絞るべき？

---

## 明日の進行順序（Recommended）

1. **Pre-Review Check**: Donna が feedback_tak_feedback_patterns.md を再確認（5 分）
2. **Proactive Self-Review**: 各メンバーが reviewer 視点で weakness を宣言（10 分）
3. **Paragraph 1-6 順次レビュー**: 本 kit の順序で（段落単位）
4. **判明済み論点**:
   - "all four nABCD values" → "all six" (Para 3)
   - R9 "third" → "fourth" on age (Para 4)
   - R2 "last on age" → "near-last" (Para 4)
   - Table rank ordering の criterion 明記（Para 2）

## 参照

- `feedback_tak_feedback_patterns.md` — Pre-Review Check source
- `feedback_review_characters.md` — 全メンバー参加ルール
- `feedback_tak_review_principles.md` — 5原則
- `feedback_sync_ja.md` — JA ファイル触らないルール
- `feedback_compaction_protocol.md` — Compaction recovery protocol（新）

---

*Rachel: "Hard work beats talent when talent doesn't work hard."*
