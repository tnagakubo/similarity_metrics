# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 - Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260212_090000.md (995 lines)

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

### Completed Revisions (This Session)

| Round | Directive | Sections Modified |
|-------|-----------|-------------------|
| Louis Review | 16 issues (3C/5M/8M) | Triage: 6 already fixed, 5 new action, 5 deferred |
| Sim v2 Analysis | BCa worse than Percentile | Decision: Percentile primary, BCa supplementary |
| Round 1 | Clinical calibration via $\Delta_{\max}$ | 2.3, 4, Abstract, 1.3, 5.1-5.3 |
| Round 2 | Remove equivalence testing | 2.3.2, 4 (judgment labels → quantitative facts) |
| Round 3 | Remove Power/Type I Error from simulation | 1.3, 3, 3.3.2, Abstract, Discussion |
| Round 4 | Harvey's 4 decisions from sim review | 3.2, 5.2, power remnant fix, S04 showcase |

### Active Tasks — Phase 8: Submission-Ready Plan (Jessica approved)

| Stage | Task | Owner | Status |
|-------|------|-------|--------|
| ~~**S1**~~ | ~~Figure 4: Estimation Quality (Coverage + CI Width)~~ | ~~Katrina~~ | **DONE** |
| ~~**S1**~~ | ~~Harvey selects: Estimation Quality figure~~ | ~~Harvey~~ | **DONE** |
| ~~**S1**~~ | ~~Harvey's 4 decisions: manuscript implementation~~ | ~~Mike~~ | **DONE** |
| **S2** | Re-review: estimation framing consistency, numerical integrity | Louis | ⏳ **NEXT** |
| **S3** | Real data strategy decision (A: public data / B: enhance hypothetical / C: reconstruct from published) | Harvey | ⏳ **Decision needed** |
| **S3** | Literature support for real data application | Rachel | ⏳ Pending |
| **S4** | LaTeX compile → PDF → Word conversion | Mike (Katrina) | ⏳ Pending |
| ~~**S4**~~ | ~~Figure files: PNG 300dpi (10K data)~~ | ~~Katrina~~ | **DONE** |
| **S4** | DOI final check (all references) | Rachel | ⏳ Pending |
| **S4** | Scenario numbering cleanup (S02/S07 gap) | Mike | ⏳ Deferred (requires fig regen) |
| **S5** | Cover letter, title page, checklist | Donna | ⏳ Pending |
| **S5** | Final Go/No-Go approval | Jessica | ⏳ Waiting |

### Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text; formal test kept as 1-sentence supplementary option
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width), not detection/equivalence power
5. **S04 showcase**: S04 (0.5σ) is the primary showcase scenario — Bias negligible, Coverage nominal, CI Width reasonable
6. **S08 overcoverage**: Non-monotonic coverage pattern explicitly discussed in Results and Limitations

### Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — deferred, requires figure regeneration
3. KS comparison in simulation — deferred, Tak decision needed

---

## Live Script

### [2026-02-12 10:00] Scene: Push — "I don't get lucky. I make my own luck."

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Harvey がジャケットの袖を直しながらブルペンに入る。全員がシミュレーション結果レビューの余韻に浸っている。Harvey の表情はそれを許さない。*

**Harvey**: （厳しい表情で、テーブルを叩いて）
「結果のレビューは終わった。いい結果だった。だがそれで満足するな。

3つの問題を見つけた：
1. **原稿に "power" の残骸が残っていた** — Section 3.2 の MCSE 記述に "coverage, power" とあった。Power は削除したはずだ。修正済み。
2. **S08 overcoverage の議論が Discussion に不足** — Results には書いたが Limitations に反映されていなかった。追加済み。
3. **S04 showcase のナラティブが弱かった** — S04 が我々の best scenario だ。Simulation summary に $\Delta_{\max}$ CI Width の具体計算とともに明示した。

"I don't get lucky. I make my own luck." 細部で負けるわけにはいかない。動け」

**Mike**: （画面を確認しながら）
「"I got it." 全修正確認した。技術的に整理すると：

1. **"coverage, power" → "coverage probabilities"** — Line 315、power の残骸を除去。正確に estimation metrics のみの記述に。
2. **Limitations 追加** — S08 の non-monotonic coverage パターン（0.573 → 0.945 → 0.996）を Limitation #3 に組み込み。bias と CI width のバランスが n で異なる rate で変化することを説明。
3. **S04 showcase paragraph** — Simulation summary 直後に追加。bias -0.003、coverage 0.950、CI width 0.18 → $\Delta_{\max}$ CI width 0.16% HbA1c。具体的な数字で reviewer を説得する」

**Katrina**: （テーブルを確認して）
「"Results speak for themselves." S04 の数字を改めて確認：

| 指標 | S04 (n=100) | 判定 |
|------|------------|------|
| Bias | -0.003 | ✅ Negligible |
| Coverage | 0.950 | ✅ Nominal |
| CI Width | 0.179 | ✅ Reasonable |
| RMSE | 0.049 | ✅ < 0.05 |

$\Delta_{\max}$ CI Width = $2 \times 0.3 \times 1.5 \times 0.179 = 0.16$% HbA1c。臨床的に十分な精度」

**Louis**: （腕を組んで）
「よし。原稿の3修正は acceptable だ。だが俺の本格 re-review はまだだ。"You just got Litt up!" は原稿全体を精査してからだ。

**Re-review checklist:**
1. estimation framing の一貫性 — 検定の残骸がゼロか再確認
2. 数値の整合性 — Tables, 本文, Abstract の全数値が v2 10K CSV と一致するか
3. $\Delta_{\max}$ calibration の論理的一貫性 — Section 2.3 → Section 4 の流れ
4. BCa 失敗の説明 — "bounded below by zero, causing the acceleration parameter to distort the quantile adjustment" で十分か

Harvey、Go を出してくれたら即座に re-review に入る」

**Harvey**: （Louis を見て）
「Go だ。S2 — Louis re-review、今すぐ始めろ。これが次のゲートだ。

**残りの bottleneck:**
- **S2: Louis re-review** — 今すぐ着手。これが全ての前提
- **S3: Real data strategy** — 俺が Tak と相談する。Public dataset か hypothetical 強化か
- **S4: Scenario numbering** — 図の再生成が必要。後回し
- **S4: DOI check** — Rachel、Louis review と並行しろ

"I don't have dreams. I have goals." 次のゴールは Louis の re-review 完了だ」

**Rachel**: （文献リストを開いて）
「"Hard work beats talent when talent doesn't work hard." DOI チェック、Louis review と並行で始めるわ。18 references 全件確認する」

**Donna**: （タブレットを掲げて）
「"I'm Donna. I know everything." 全て記録完了。

**本日の進捗:**
- ✅ Harvey's 4 decisions → 原稿反映（3件実施、scenario renumbering は deferred）
- ✅ Power 残骸修正
- ✅ S08 overcoverage を Discussion に追加
- ✅ S04 showcase paragraph 追加
- ✅ SUITS.md アーカイブ（995行 → archives/SUITS_20260212_090000.md）

**次のアクション:**
- ⏳ Louis re-review (S2) — **Gate task**
- ⏳ DOI final check — Rachel 並行
- ⏳ Real data strategy — Harvey/Tak 相談」

---

### [2026-02-12 09:00] Scene: Meeting — Simulation Results Review

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey が大型ディスプレイにシミュレーション結果テーブルを映す。全メンバー着席。コーヒーの香りが漂う朝のミーティング。*

**Harvey**: （立ったまま、テーブルを見回して）
「10,000 replications が完了した。これは試運転じゃない。本番の結果だ。全員の目でレビューしろ。見落としがあれば今日中に潰す。意見を聞かせろ」

**Mike**: （ディスプレイを指しながら）
「"I got it." 技術的な所見を整理する。

**1. Bias — 想定通り、問題なし**

| Scenario | n=50 | n=100 | n=200 | 判定 |
|----------|------|-------|-------|------|
| S01 (Null) | +0.093 | +0.066 | +0.047 | 境界効果 — 予想通り |
| S03 (0.2σ) | +0.039 | +0.018 | +0.007 | ✅ n≥100 で < 0.02 |
| S04 (0.5σ) | +0.004 | -0.003 | -0.004 | ✅ 全 n で negligible |
| S05 (1.0σ) | -0.038 | -0.041 | -0.043 | ⚠️ 持続的負バイアス |
| S06 (Scale) | +0.001 | -0.012 | -0.019 | ✅ n≥100 で < 0.02 |
| S08 (Shape) | +0.029 | +0.003 | -0.015 | ✅ n≥100 で < 0.02 |

S05 の負バイアス約 -0.04 は bounded statistic の性質。nABCD は [0, ∞) だが、true value 0.372 が実効的な上限に近いため、推定値が下に引っ張られる。これは正直に Discussion に書いている。

**2. Coverage — 核心的な話題**

Percentile CI の Coverage:

| Scenario | n=50 | n=100 | n=200 |
|----------|------|-------|-------|
| S03 (0.2σ) | 0.672 | 0.895 | **0.949** |
| S04 (0.5σ) | **0.956** | **0.950** | **0.949** |
| S06 (Scale) | **0.963** | **0.976** | **0.939** |
| S08 (Shape) | 0.573 | **0.945** | **0.996** |
| S05 (1.0σ) | **0.929** | 0.867 | 0.731 |

n≥100 で bold = 0.90 以上。S04, S06, S08 は n≥100 で excellent。S03 は n=100 で 0.895 — ギリギリ acceptable。S05 は known issue。

注目すべきは **S08 (Shape) n=200 の 0.996** だ。これは overcoverage — CI が広すぎることを意味する。Shape scenario では分布の非対称性が影響している可能性がある」

**Katrina**: （Figure 4 を投影しながら）
「"Results speak for themselves." Figure 4 のパネル B — CI Width を見てほしい。

| Scenario | n=50 | n=100 | n=200 |
|----------|------|-------|-------|
| S03 | 0.181 | 0.135 | 0.106 |
| S04 | 0.229 | 0.179 | 0.134 |
| S05 | 0.243 | 0.172 | 0.121 |
| S06 | 0.186 | 0.131 | 0.094 |
| S08 | 0.165 | 0.113 | 0.078 |

n を 2 倍にすると CI Width が約 25-30% 縮小する。$\sqrt{n}$ rate と整合。n=100 で 0.11-0.18 の範囲。

Clinical calibration の観点: $L = 0.3$, IQR = 1.5% の HbA1c に対して、S04 (n=100) の CI Width 0.179 は $\Delta_{\max}$ の CI Width $= 2 \times 0.3 \times 1.5 \times 0.179 = 0.16$% HbA1c に相当する。臨床的に意味のある精度だ」

**Harvey**: （全員を見渡して、決断）
「結果はレビューに耐えうる。以下を決定する。

**Decision 1**: S04 を primary showcase scenario として論文のナラティブの中心に据える。
**Decision 2**: Louis の 3 指摘を全て manuscript に反映。特に MCSE 明示と BCa 失敗理由。
**Decision 3**: S08 の overcoverage の非単調パターンを Discussion で議論。
**Decision 4**: $\Delta_{\max}$ CI Width の具体計算を Section 4 に追加。

Mike、Louis の指摘の manuscript 反映を担当しろ。Katrina、Section 4 の $\Delta_{\max}$ 計算追加。

"I don't have dreams, I have goals." 次は Stage 2 — Louis の full re-review だ」

---
