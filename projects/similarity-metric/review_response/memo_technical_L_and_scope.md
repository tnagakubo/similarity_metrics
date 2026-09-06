# Technical Response Memo: L_UB 導出・operability・binary EM scope（模擬査読対応）

**対象原稿**: `projects/similarity-metric/paper/per_em_W1_wiley.tex`（行番号は 2026-09-06 時点の同ファイル）
**対象コメント**: R1.2/R2.1（L_UB の妥当性 — critical pair）、R2.2（operability の α・多重性・noise）、R2.4（near-null coverage との接続）、R1.1（binary EM scope）
**性質**: 対応方針メモ。原稿の編集は行っていない（編集は PI の paragraph review を経る）。
**数値ソース**: `projects/similarity-metric/results/gusto_operability.csv`（production, seed 20260821, B=2,000）、`projects/similarity-metric/R/gusto_operability_check.R`、`projects/similarity-metric/review_response/tmp_floor_sensitivity.R`（本メモ用の使い捨て検証, seed 20260906）、tex 本文、`projects/similarity-metric/paper/supplement_L_clinical_lit.md`（= Supplement D）。本メモ中の全比率は下記の元数値からの単純除算（例: 0.646356 / 0.723618 = 0.893）。
**Governance 適合**: 本メモは (i) 具体的 CATE 関数 θ/τ を指定する simulation を一切提案しない（KR duality により循環になるため — project 決定 2026-07-12）、(ii) ρ = W1/(KS·σ_EM) heuristic の method 化を提案しない、(iii) estimation-centered な言葉遣いを維持する（"significant" 不使用）、(iv) RV2/RV3 は本 project の拡張であり小宮山の手法と呼ばない、という制約の下で書かれている。

---

## 1. R1.2/R2.1(a) — 「prognostic gradient と predictive gradient の混同」

### 1.1 原稿の現状（tex 行番号）

- **L174**（§2.4）: L_clinical を CATE の Lipschitz constant と定義した直後、「When L_clinical is estimable from prior data, individual patient data (IPD) meta-regression on treatment-by-covariate interaction provides a per-unit slope directly, and the same quantity is denoted the interaction slope in the methodological literature.」
- **L190**（§2.4）: 「``Conservative'' here indicates that the chosen bounds exceed the empirical prognostic age slope of approximately 6×10⁻³ per year reported by Lee et al., so that any plausible CATE sensitivity falls below them.」 ← R1.2(a) の直接の標的。
- **L563**（§4.4）: 「class-level meta-analytic evidence … supports a conservative upper bound of approximately 10%pt per decade … exceeding the empirical prognostic gradients in Lee et al.」
- **Supplement D §0.7**（`supplement_L_clinical_lit.md` L293–298）: 「a treatment effect cannot vary across an EM faster than baseline risk varies」を「natural ceiling」として明記。§0.8 L306 では「physically meaningful upper bound」とまで言う。一方で同 §0.8 L312 は「No published source provides a directly-tabulated L_clinical,age … frames the bounds as *illustrative class-level*」と、本文（L190）より正直な位置づけを既に書いている。

### 1.2 Honest assessment: **VALID（有効な指摘）**

- Prognostic gradient（∂ baseline risk / ∂x、main effect）と CATE gradient（∂τ/∂x、interaction）は別の量であり、「modifying slope ≤ prognostic slope」を保証する定理は存在しない。risk-difference scale で τ(x) = R₀(x) − R₁(x) と分解すれば **|τ′(x)| ≤ |R₀′(x)| + |R₁′(x)|** が成り立つのが正確な関係で、CATE gradient を抑えるのは「各 arm の risk gradient の**和**」であって片側の prognostic gradient 単体ではない。極端な場合（治療が age 依存性を完全に除去: R₁′ = 0）に τ′ = R₀′ となり prognostic gradient に**到達**し、両 arm の gradient が逆符号なら**超え得る**。
- さらに Lee et al. の 6×10⁻³ /yr 自体が**平均勾配**（<45歳 1.1% → >75歳 20.5% を約30年で均したもの; Supplement D §0.5 L268–269）。logistic model の局所勾配は高齢域で急峻になるため、参照点そのものが局所では 1×10⁻² /yr 級になり得る。よって「1×10⁻² は 6×10⁻³ を超えるから、あらゆる plausible な CATE sensitivity はその下にある」（L190）は演繹ではなく、**臨床的 plausibility 判断を演繹の体裁で書いてしまった**もの。
- チームの working hypothesis（L_UB を evidence-derived bound ではなく **illustrative・sponsor 責任の clinical input** として再配置する）は妥当と評価する。理由: (i) Supplement D §0.8 が既に同じ位置づけを取っており、本文 L190/L563 だけが supplement より強い主張をしている（本文を supplement 側に揃えるだけで整合する）; (ii) 原稿には既に L_UB を 0.8–2 倍に振る sensitivity analysis（L602–604）があり、「判断入力＋頑健性提示」という構造が完成している; (iii) L* pathway（L188, L472）は bound を主張せず required sensitivity を報告する設計で、これが application の実際の経路である。**ただし** L* > L_UB の eligibility 判定（L565）には L_UB が比較対象として残るため、「illustrative 化」は逃げ切りではなく「結論は stated bounds に条件付き」への降格を意味する — これは正直に letter に書くべき。

### 1.3 Response options

**Option A（推奨）: illustrative 再配置 ＋ arm-decomposition による正確な情報関係の明示**
- L190/L563 の「so that any plausible CATE sensitivity falls below them」型の演繹的主張を撤回し、L_UB を「sponsor が指定する illustrative な clinical input」と再定義。prognostic gradient は「bound の根拠」ではなく「判断の参照点」に降格し、その参照が正当化される正確な形として |τ′| ≤ |R₀′| + |R₁′|（各 arm の局所 risk gradient が押さえられている場合に限り和が上界）を一文で示す。sensitivity analysis（L602–604）を頑健性の主担ぎ手として明示。
- 利点: 数学的に正確、Supplement D と整合、application の数値・結論は不変（bounds の値は変えない）、追加計算ゼロ。
- 欠点: 「では 1×10⁻² の選択自体は何に基づくのか」に対し「clinical judgment ＋ sensitivity analysis」以上の答えを持たなくなる。査読者が「arbitrary」と再攻撃する余地は残る（が、現行の誤った演繹よりは防御可能。margin 設定が sponsor 責任であるのは non-inferiority design と同型、という位置づけで受ける）。

**Option B: prognostic 参照の全面削除（純 illustrative 化）**
- Lee 由来の数値参照を本文から外し、bounds を純粋に「what-if の illustrative 値」と宣言（Supplement D §5.1 の option 3 相当）。
- 利点: 論理的に最も攻撃面が小さい。
- 欠点: 数値の由来が完全に無根拠化し「なぜ 1×10⁻² なのか」に一切答えられない。empirical anchoring を失うのは Stat Med 査読では悪手。sensitivity analysis の解釈（0.8×–2× の範囲の妥当性）も宙に浮く。**非推奨**。

### 1.4 Draft reply-letter（(a) に対する回答、Option A ベース）

> We agree. A prognostic gradient (a main-effect risk gradient) and a treatment-effect gradient (the derivative of the CATE) are distinct quantities, and no deductive argument licenses the step from "the chosen bound exceeds the empirical prognostic slope" to "any plausible CATE sensitivity falls below it." We have removed that inference. In the revision, L_UB is presented as what it in fact is: an illustrative, sponsor-specified clinical input, on the same footing as a non-inferiority margin — a quantity for which the sponsor carries clinical responsibility, informed but not determined by prior evidence. The precise sense in which prognostic gradients inform that judgment is now stated: on the absolute-risk scale, τ(x) = R₀(x) − R₁(x), so |τ′(x)| ≤ |R₀′(x)| + |R₁′(x)|; arm-level risk gradients therefore constrain the modification slope only jointly, and only where the arm-specific local gradients are themselves bounded — a fitted average gradient can understate the local one. Because the bounds are judgments rather than estimates, the case-study conclusions are explicitly conditional on them, and the sensitivity analysis of Section 4.4 — which reports how the partner selection degrades as each bound is varied from 0.8 to 2 times its stated value, with the critical scaling factors at which individual regions cross — is now framed as the primary robustness statement accompanying that judgment. Supplement D already characterized the bounds as illustrative class-level anchors rather than empirical point estimates; the main text has been brought into line with that characterization.

（Option B を採る場合は、上記から arm-decomposition の文を落とし、"informed but not determined by prior evidence" を "declared without empirical anchoring, as a demonstration of the framework's mechanics" に差し替える。）

### 1.5 編集が必要な箇所（列挙のみ）

- L190（§2.4）: 「Conservative here indicates … falls below them」の文。
- L563（§4.4）: 「supports a conservative upper bound … exceeding the empirical prognostic gradients」の文。
- L688（Discussion, limitations）: L_UB が clinical judgment input である旨の明示を追加。
- Supplement D §0.7 表・§0.8 defense line 1（「physically meaningful upper bound」「natural ceiling」）: arm-decomposition 表現へ弱める。
- L159（§2.2 末尾）が「for threshold or step-function CATEs … (Section 6)」と Discussion への言及を約束しているが、Discussion に対応段落が存在しない（grep 確認済み: CATE 文脈での "step-function"/"threshold or"/"arbitrarily large" の出現は L159 のみ。L163 の "step functions" は ECDF の記述で無関係）。§2 の下記 (b) 対応と併せて Discussion に limitation 段落を新設。

---

## 2. R2.1(b) — 「meta-regression の interaction slope は Lipschitz constant ではない」

### 2.1 原稿の現状（tex 行番号)

- **L145–157**（§2.2）: Proposition 1 は「τ が Lipschitz constant L_clinical で Lipschitz 連続」を仮定し、KR duality（eq. dual, L141–144）から |τ̄₁ − τ̄₂| ≤ L·W₁ を導く。仮定は sup|τ′| ≤ L と同値（絶対連続なら）。
- **L174**（§2.4）: IPD meta-regression が「per-unit slope を directly に提供する」と記述 — ここが linear interaction model の平均傾きと sup|τ′| の混同点。
- **L78**（Intro）および **L40**（abstract）: 非線形 effect modification を W₁ 採用の動機として明示（「When effect modification is non-linear, these features directly influence regional average treatment effects」）。査読者の「motivates with non-linearity, calibrates with linearity」はこの対比を突いている。
- **L159**: threshold/step CATE では L が任意に大きくなり bound が保守化する旨は既に認めている（ただし前述の通り Discussion の受け皿が無い）。

### 2.2 Honest assessment: **数学的指摘としては VALID。ただし「内部矛盾」との評価は過大**

- 指摘の核は正しい: linear interaction model の係数 β̂ は τ の線形射影の傾き（平均傾き）であり、非線形 τ では sup|τ′| > |β| になり得る。したがって **β̂ をそのまま L に代入した Δ_max は上界を保証しない**。L174 の「provides a per-unit slope directly」は、この区別を消しており修正必須。
- 一方、「非線形で動機づけ、線形で較正」という**内部矛盾**の主張は範囲が広すぎる。Proposition 1 の較正は linear τ を仮定していない — Lipschitz τ（非線形含む）で成立する。脆弱なのは「数値 L をどこから持ってくるか」という **specification 経路の一箇所**（L174）だけである。この切り分けが reply の第一手。
- さらに、GUSTO application は **meta-regression 由来の L を一切使っていない**（L472: 両 EM とも L unknown として L* pathway を適用）。つまり指摘された誤用は application では犯されておらず、Methods の一文の問題である。
- **Bound が成立するために必要なもの**（reply に載せる内容として整理）:
  1. **前提の明示**: Δ_max が上界であるのは premise「sup|τ′| ≤ L」の下でのみ。L を推定量（平均傾き）から作る場合、この premise は追加の仮定であり、無償では得られない。
  2. **Safety factor**: β̂ から L を作るなら乗法的安全係数 κ（sponsor 指定、例 2–3）を掛けて L_UB = κ|β̂| とする。非劣性 margin の discounting と同型の、判断としての保守化。
  3. **局所性（bound の実際の要求は全域 sup より弱い）**: 部分積分恒等式 τ̄₁ − τ̄₂ = −∫τ′(x)(F₁(x) − F₂(x))dx より、|τ̄₁ − τ̄₂| ≤ ∫|τ′||F₁−F₂|dx ≤ (sup_{x∈S}|τ′|)·W₁、ここで S = {x : F₁(x) ≠ F₂(x)}。つまり L は**両地域の CDF が実際に異なる範囲**でのみ |τ′| を押さえればよい。観察範囲外での τ の飽和・急峻化は bound に影響しない。（注: 飽和 θ で bound が緩む件は project 決定の通り「保守的上界という設計思想」であり、修理対象ではない。この恒等式は設計思想の範囲内での正確化である。）
  4. **形状制約下の特別な場合**: τ が単調かつ凹（または凸）と臨床的に主張できるなら、sup|τ′| は観察範囲の**端点**で達成される（τ′ が単調のため）。このとき必要な定数は「端点近傍の局所傾き」という**識別可能な**量になり、全域 linear fit の平均傾きではなく端点局所の傾き推定が L の正しい標的になる。また任意の τ に対し観察範囲の chord slope は sup|τ′| の**下界**であり、L_UB が chord slope を下回れば L_UB は反証される、という整合性チェックに使える。（いずれも「何が必要か」の記述であり、新手法・新 simulation の提案はしない。）
  5. **L\* pathway による部分的回避**: L* = Δ_clin/W₁ は bound を主張しない — 「観測された W₁ が臨床的に意味を持つには sup|τ′| がどれだけ必要か」を報告する逆算であり、それ自体は仮定なしの算術。Lipschitz か平均傾きかの gap は、最終比較「L* vs L_UB」すなわち sponsor の plausibility 判断に移転する。回避は部分的（判断は残る）だが、「framework が誤った保証を出力する」構造ではなくなる。

### 2.3 Response options

**Option A（推奨）: L174 修正 ＋ premise の明示 ＋ 緩和策 3 点（safety factor・局所性・形状制約）を追記**
- L174 を「meta-regression は平均 interaction slope を与える。これは Lipschitz constant の下界であって constant そのものではない」に改め、slope 由来の L には κ を要求。Proposition 1 直後か Appendix に部分積分の局所性 remark を追加。Discussion に L159 が約束した limitation 段落を新設し、step CATE の保守化と slope-vs-sup gap をまとめて受ける。
- 利点: 数学的に完結し、査読者の正しい点を全面的に取り込みつつ「内部矛盾」評価を正確に狭められる。application 数値は不変。
- 欠点: §2.4 が長くなる。κ の値自体はまた判断であり、「κ の根拠は」と再質問され得る（→ sponsor 判断＋sensitivity で受ける、と (a) と同じ構造で閉じる）。

**Option B: 主張の降格（bound 語彙の条件付け）**
- L を推定平均傾きから取った場合の Δ_max を「upper bound」と呼ばず「linear-calibration approximation」と改名し、bound の語は sup-slope premise が明示的に主張された場合に限定する。
- 利点: 最も誠実で、過大主張が構造的に不可能になる。
- 欠点: framework の売り（clinically interpretable **bound**）が主要経路で弱まり、abstract・§2.4・Discussion の広範な書き換えが要る。Option A が premise 明示で同じ誠実さを達成できるため、費用対効果で劣る。**A を推奨、B は fallback**。

### 2.4 Draft reply-letter（(b) に対する回答、Option A ベース）

> The reviewer is correct on the mathematical point, and we have revised the manuscript accordingly. An interaction slope from an IPD meta-regression of a linear interaction model is an average slope — the projection of τ onto linear functions — not the Lipschitz constant sup|τ′| that Proposition 1 requires; for non-linear τ the local slope can exceed the fitted one, and a Δ_max computed from such an L is not guaranteed to be an upper bound. Section 2.4 previously said that meta-regression "provides a per-unit slope directly"; it now states that it provides an average slope, which is a lower bound on the Lipschitz constant, and that an L specified from such an estimate must carry a sponsor-specified multiplicative safety factor, in the spirit of margin discounting in non-inferiority design, with the resulting Δ_max explicitly conditional on the premise sup|τ′| ≤ L.
>
> We would, however, resist the inference that the paper motivates the metric with non-linearity and calibrates it with linearity. Proposition 1 assumes Lipschitz continuity, not linearity; the calibration is valid for non-linear τ. The gap the reviewer identifies is confined to one specification route for the numerical value of L — and the case study does not use that route: for both effect modifiers the application treats L as unknown and uses the reverse-calculation pathway, which asserts no bound but reports the sensitivity L* that the observed W₁ would require to matter clinically, transferring the Lipschitz judgment to the explicit comparison of L* with the stated bound. Two further points now stated in the revision sharpen what the premise demands. First, by the identity τ̄₁ − τ̄₂ = −∫τ′(x)(F₁(x) − F₂(x))dx, the constant need only dominate |τ′| on the set where the two regional distribution functions differ; behaviour of τ outside the region of distributional disagreement — including saturation — does not enter the bound. Second, when τ can be defended as monotone with a known direction of curvature, the supremum of |τ′| over the relevant range is attained at an endpoint of that range, so the required constant is identified by a local slope there rather than by an unidentifiable supremum; and for any τ, the chord slope across the observed range is a lower bound on sup|τ′|, giving a falsification check on any proposed L_UB. The limitation paragraph promised in Section 2.2 for threshold-type CATEs, for which the bound is conservative by design, now appears in the Discussion and covers the average-slope gap as well.

### 2.5 編集が必要な箇所（列挙のみ）

- L174（§2.4）: 「provides a per-unit slope directly」の文（本コメントの核）。
- L157–159 直後（§2.2）または Appendix: 部分積分の局所性 remark の追加位置。
- Discussion（L688 の limitation 段落周辺）: L159 が予告した Lipschitz limitation 段落の新設（step CATE の保守化＝設計思想、slope-vs-sup gap、safety factor）。
- L188（§2.4）: L* pathway の記述に「Lipschitz 判断は L* vs L_UB 比較に残る」旨の一文。
- L40（abstract）: 「when prior evidence on CATE sensitivity (L) is available」の句 — 推定 slope でなく bound である旨を一語で反映するか検討（軽微、任意）。

---

## 3. R2.2 — operability の (a) α と q の推定手続き、(b) 30 同時チェックの family-wise 挙動、(c) null floor の noise と 6 つの unresolved 判定の感度

### 3.1 実装の事実（コード・データで確認済み）

`R/gusto_operability_check.R` より:
- **α = 0.05、one-sided**（L40: `ALPHA <- 0.05`; L24–26 のコメント「alpha = 0.05 (one-sided)」）。
- **null replication 数 B = 2,000 / partner**（L39）。seed 20260821 記録（L38）。
- **Resampling scheme**（L16–22, L51–58, L87–91）: anchor R8 の empirical distribution から、**独立な 2 標本を with replacement で** サイズ (n_anchor=2,916, n_partner) で抽出し Ŵ₁ を再計算 × B 回。floor は partner ごと（両標本サイズに依存するため）。**q は B 個の null draw の empirical (1−α) quantile**（L57: `quantile(v, 1 - alpha)`）。
- **Partner-drawn floor も全 partner で計算**し（L91）、verdict の感度チェックとして両者を比較（L125–135）。CSV に `null_mean_anchor, null_q95_anchor, null_mean_partner, null_q95_partner, resolved_anchor, resolved_partner` の両系列が保存されている。
- **多重性調整は一切実装されていない**（スクリプト全体に補正なし）。30 チェック（15 partners × 2 EMs）が各々 α = 0.05 で並ぶ。

原稿側: §2.5 は scheme 自体は記述済み（L212）だが「The level α is left free here; the choice made for the case study is stated in Section 4」（L210）で α と B は §4.2（L494）に置かれている。

### 3.2 Honest assessment

- **(a) partially valid**: resampling scheme は Methods にある（L212）が、α の値・B・「empirical quantile を使う」ことは §4.2 にしかない。Methods へ移すべきという要求は正当で、コスト・ゼロで応じられる。**付随して発見した不整合**: L214 は「the operability condition nonetheless fails for one of the two candidate effect modifiers」と書くが、§2.5 の条件 (eq. operability, L206–209) は τ_clin > q₀.₉₅ であり、これは **age の全 15 partner で成立している**（age: q₀.₉₅ range 0.618–0.900 < τ = 1.0; SBP: 1.176–1.691 < 5.0。CSV 全行）。L214 の「fails」は §4.2 の per-partner unresolved 判定（w1_obs ≤ q₀.₉₅、6/15）を指す別の主張であり、用語が二義的。あわせて L214 の「the regional samples exceed two thousand observations」も 4 partner（R16 n=1,231, R6 n=1,585, R10 n=1,717, R5 n=1,909; CSV n_partner 列）で不正確。要修正。
- **(b) valid（議論要求として）**: 未調整は事実。ただし方向が重要（下記）。
- **(c) valid**: floor は推定値でありノイズを持つ。定量的に答える（下記）。

### 3.3 (b) family-wise 挙動 — 分析と新規計算

**構造的な論点**: 30 チェックは confirmatory な検定 family ではなく per-partner の diagnostic flag であり、「resolved」を類似性の主張に転用しない設計（L509–513 が明示: unresolved+eligible は「類似の証拠にならない」側にのみ使う）。古典的 FWER が守る誤り（真に同一分布なのに resolved と誤呼称）の意思決定上の帰結は良性である: 真に同一なら pooling は正当で、失われるのは注意フラグだけ。**有害な方向（真の差を見えないのに eligible 扱い）は unresolved フラグ側で、floor を厳しくするほどフラグは増える**。したがって多重性調整は結論を危うくする方向には働かない。

**数値確認**（`review_response/tmp_floor_sensitivity.R`, seed 20260906; Bonferroni 型 simultaneous floor q_{1−0.05/30} = q₀.₉₉₈₃ を B = 10,000 で推定。w1_obs は production CSV と一致することを確認済み）:

| EM | Partner | w1_obs | q₀.₉₅ (新 seed) | q_{1−0.05/30} | verdict @ q₀.₉₅ | verdict @ q_{1−0.05/30} |
|---|---|---|---|---|---|---|
| age | R6 | 0.9121 | 0.8007 | 1.1995 | resolved | **unresolved に flip** |
| age | R12 | 0.8591 | 0.6155 | 0.9085 | resolved | **unresolved に flip** |
| age | R14 | 0.7023 | 0.6441 | 0.9530 | resolved | **unresolved に flip** |
| sysbp | R13 | 2.3999 | 1.3764 | 2.0766 | resolved | resolved（不変） |

- q_{1−0.05/30}/q₀.₉₅ の観測比は 1.48–1.51（4 partner）。この比を残りの resolved partner に外挿すると、age では他に flip なし（最接近は R13-age: w1 1.1451 vs 外挿 floor ≈ 1.04–1.06、約 8–10% 上; CSV の w1_obs, null_q95_anchor 列から計算）、SBP では R13 が検証済み最小 margin（w1/q₀.₉₅ = 2.3999/1.3711 = 1.750）で直接計算により resolved のまま、他は全て比 ≥ 2.06 で flip なし。
- **帰結**: simultaneous floor の下で age の unresolved は 6/15 → **9/15**（R6, R12, R14 が加わる; うち R6/R12/R14 は直接計算で確認、他の非 flip は比の外挿）。SBP は 14/15 resolved のまま不変。さらに age では小規模 partner の q_{1−0.05/30} が τ_clin = 1.0 を**超える**（R6: 1.20, R1: 1.03, R15: 1.03; tmp 出力）— simultaneous 版では eq. (operability) の条件そのものが age の一部 partner で不成立になる。いずれも原稿の中心メッセージ「**SBP が意思決定を担い、age の寄与は部分的**」（L509, L606）を弱めるのではなく**強める**。
- なお §4 の partner 選定（jointly eligible 6 regions: R1, R4, R5, R6, R14, R15; L596）は resolved フラグを入力に使っておらず（eligibility は L* vs L_UB の点推定比較; L565、CSV `eligible` 列 = w1_obs ≤ τ）、多重性調整で選定は変化しない。変化するのは L503（Table 5 の「6 / 15」）、L509（「nine of the fifteen」）等の記述カウントのみ。

### 3.4 (c) unresolved 6 判定の noise 感度 — CSV 数値

Production CSV（age 行、anchor-drawn floor）での **w1_obs / q₀.₉₅ 比**（値は `w1_obs` ÷ `null_q95_anchor`）:

| Partner | w1_obs | q₀.₉₅ | 比 | q₀.₉₅ − w1_obs | 評価 |
|---|---|---|---|---|---|
| R5 | 0.3899 | 0.7487 | 0.521 | 0.359 | floor の深部 — 頑健 |
| R7 | 0.4047 | 0.6409 | 0.632 | 0.236 | 深部 — 頑健 |
| R4 | 0.5555 | 0.6915 | 0.803 | 0.136 | 中間 |
| R9 | 0.5860 | 0.6629 | 0.884 | 0.077 | **marginal** |
| R1 | 0.6464 | 0.7236 | 0.893 | 0.077 | **marginal** |
| R15 | 0.6103 | 0.6834 | 0.893 | 0.073 | **marginal** |

（参考: resolved 側の marginal は R14 比 1.076、R6 比 1.118、R12 比 1.390。）

ノイズの大きさの評価:
1. **Monte Carlo（B = 2,000 での q₀.₉₅ 推定誤差）**: 独立 seed による再計算（tmp スクリプト）で q₀.₉₅ の変動は R1: 0.7236→0.7143（−1.3%）、R9: 0.6629→0.6795（+2.5%）、R15: 0.6834→0.6936（+1.5%）、R6: 0.8156→0.8007（−1.8%）、R12: 0.6182→0.6155（−0.4%）、R14: 0.6525→0.6441（−1.3%）、R13-sbp: 1.3711→1.3764（+0.4%）。**最大 2.5%**。marginal 3 partner（R1/R9/R15）の floor までの距離は 10.7–11.6% あり、seed を変えても全 verdict 不変（tmp 出力の resolved_at_q95 列が production と全一致）。
2. **Null source の選択**: anchor-drawn と partner-drawn の 30 行すべてで verdict 一致（CSV の resolved_anchor 列 = resolved_partner 列、全 30 行; production log の sensitivity 節でも「none」）。原稿 L511 の記述と整合。
3. **仮に flip しても §4 の結論は不変**: 選定（6 jointly eligible）は resolved フラグ非依存（§3.3 末尾と同じ理由）。marginal-unresolved 3 つが resolved に flip すれば注意フラグ集合が 6→3 に縮むだけで「age は部分的に unresolved、SBP が担ぐ」は不変; 逆方向（floor 厳格化）は §3.3 の通り 9/15 でむしろ強化。書き換わるのはカウントの文言（L503, L509, L513, L606）に限られる。

### 3.5 Response options

**Option A（推奨）: Methods への明記 ＋ simultaneous-floor sensitivity の追記**
- §2.5 に α = 0.05（one-sided）、B = 2,000、empirical quantile、per-partner 計算、anchor-drawn null（partner-drawn を感度）を明記（L494 から昇格）。§4.2 に多重性の段落を追加し、q_{1−0.05/30} での再計算結果（age 6→9 unresolved、SBP 不変、選定不変）を 2–3 文で報告。数値は production pipeline（`gusto_operability_check.R` の拡張、seed 記録）で再生成してから本文に入れる（本メモの tmp 数値は検証用）。
- 利点: 3 つの sub-question を全部、既存の結論を強める形で吸収。計算コストは数分。
- 欠点: §4.2 がやや長くなる。

**Option B: Methods への明記 ＋ 多重性は概念的回答のみ**
- (a)(c) は A と同じ、(b) は「flags であって family of tests ではない; 調整は unresolved を増やす方向にしか働かない」という方向性議論だけで返す。
- 利点: 本文追加が最小。
- 欠点: 「discuss the family-wise behaviour」に定量で答えないと R2 は再質問する可能性が高い。数値が結論を強めるのに出さないのは戦略的にも損。**A を推奨**。

### 3.6 Draft reply-letter

> (a) The Methods section now states the full specification, previously split between Sections 2.5 and 4.2: the level is α = 0.05, one-sided; the null floor quantile is estimated as the empirical 95th percentile of B = 2,000 recomputations of Ŵ₁ on pairs of independent resamples drawn with replacement from the anchor region's empirical distribution at the two actual sample sizes, computed separately for each partner because the floor depends on both sizes; the floor drawn from the partner's own distribution is recomputed as a sensitivity, and every one of the 30 verdicts agrees between the two choices. Code and seed are provided.
>
> (b) The 30 comparisons are reported as per-partner diagnostic flags, not as a family of confirmatory tests, and no family-wise claim was attached to them; but the reviewer's question has a quantitative answer with a reassuring direction. An unadjusted floor can err only toward calling partners resolved; the safeguard the check provides — the unresolved flag — grows, not shrinks, under any simultaneous adjustment. Recomputing the floors at the Bonferroni-style quantile q_{1−0.05/30} flips exactly the three marginal age verdicts (R6, R12, R14) to unresolved, enlarging the unresolved set on age from six to nine of fifteen, while no verdict on systolic blood pressure changes. The partner selection itself is unaffected, because eligibility is determined by the comparison of Ŵ₁ with τ_clin, not by the resolved flags. The manuscript's conclusion that systolic blood pressure carries the decision is therefore strengthened, not weakened, under simultaneous control, and we now say so in Section 4.2.
>
> (c) The six unresolved age verdicts sit at observed-to-floor ratios of 0.52 (R5), 0.63 (R7), 0.80 (R4), 0.88 (R9), and 0.89 (R1, R15): three are deep inside the floor, and three lie within 12% of it. The Monte Carlo noise in the estimated floor is an order of magnitude smaller than those margins — re-estimating every marginal partner's floor with an independent seed moved the 95th percentile by at most 2.5%, changing no verdict — and every verdict is likewise invariant to drawing the null from the partner rather than the anchor. More importantly, no flip in either direction would alter the Section 4 conclusions: the joint eligibility of the six selected partners does not use the resolved flags, and the only sentences that would change are the counts describing how many partners age helps to discriminate. We report these margins in the revision so the reader can see which verdicts are marginal.

### 3.7 編集が必要な箇所（列挙のみ）

- L210–212（§2.5）: α・B・empirical quantile・null source の明記（L494 からの昇格）。
- L214（§2.5）: 「operability condition … fails for one of the two candidate effect modifiers」の二義性解消（eq. (8) は両 EM で成立、fails の実体は per-partner unresolved 6/15）と「exceed two thousand」の数値修正（4 partner は 2,000 未満）。
- L494（§4.2）: 重複整理（Methods へ移した分）。
- §4.2 L509–513 の後: simultaneous-floor sensitivity の段落追加、marginality（w1/q₀.₉₅ 比）の報告。
- Table 5（L496–507）注記: α、B、seed の明記。

---

## 4. R2.4 — near-null coverage erosion と operability check の接続

### 4.1 原稿の現状（tex 行番号）

- **L393 / L408 / L418**: S2（0.2σ shift、真の W₁ = 2.0、σ = 10 指定は L443）で coverage 0.703（n=50）→ 0.904（n=100）→ 0.947（n=200）。boundary proximity が原因と記述。
- **L447**: S1（null）の平均推定値 = null floor 平均: 2.46（n=50）、1.26（n=200）。**L455**: S1 bias 1.76（n=100）＝ null floor 平均（真値 0 のため）。
- **L203–209**（§2.5）: operability check は τ_clin を null floor の分位点と比較する — 査読者の記述の通り、near-null での coverage erosion そのものは対象にしていない。
- **L447 末尾**: 「This boundary behaviour is the operability phenomenon of Section 2.5 in its simplest instance」— 接続の**萌芽**は既にあるが S1（真値 0）のみで、S2（真値 > 0 の near-null）への橋は張られていない。

### 4.2 Honest assessment: **VALID — ただし橋は原稿自身の数値で架かる**

査読者の言う「null と well-separated の間の近傍」は定量化できる。S2 の真値 W₁ = 2.0 を各 n の null floor 平均と比べると:

| n | null floor 平均（出典） | 真値 / floor 平均 | S2 coverage（L408） |
|---|---|---|---|
| 50 | 2.46（L447） | 2.0/2.46 = **0.81** | 0.703 |
| 100 | 1.76（L455） | 2.0/1.76 = **1.14** | 0.904 |
| 200 | 1.26（L447） | 2.0/1.26 = **1.59** | 0.947 |

Coverage erosion は真値が floor の**内側〜近傍**にある間だけ起こり、floor を離れるにつれ nominal に回復する — S2 の 3 点はこの gradient をそのまま描いている。つまり operability check が flag する regime（観測距離が floor 内）と coverage が壊れる regime は同一原因（非負性境界）の二つの顔であり、check は erosion が起こる領域の **per-partner での見張り**になっている。

**残る gap（正直に認める点）**: (i) erosion は滑らかで、check の verdict は二値 — floor をわずかに超えた「resolved だが marginal」な partner（GUSTO では R14 比 1.08、R6 比 1.12、R12 比 1.39; §3.4 の表）は遷移帯に居り、その CI は nominal と degraded の中間であり得る。(ii) GUSTO の unresolved 6 partner の w1_obs / floor 平均比は 0.89–1.53（例: R5 0.3899/0.4401 = 0.89、R1 0.6464/0.4249 = 1.52; CSV の w1_obs, null_mean_anchor 列）で、まさに S2 型遷移帯に相当し、Table 3 のこれら partner の bootstrap CI（例 R5 [0.35, 0.92]; L530）は近似としてしか読めない。ただし判定層はこれらの CI に依存していない（eligibility は点推定比較; L565）ので、影響は「CI の読み方の注意」に限局される。

### 4.3 Response options

**Option A（推奨）: 定量ブリッジ＋残余 gap の明文化**
- §2.5（または §3 の S1/S2 論述部）に上表の 3 点対応（0.81/1.14/1.59 ↔ 0.703/0.904/0.947）を 2 文で追加し、「check は erosion の起こる regime の per-partner flag だが、遷移は滑らかで verdict は二値」という residual を明記。§4.2 に「unresolved および marginal-resolved partner の CI は近似として読む。判定層はこれらの CI に依存しない」の注意を 1 文。
- 利点: 査読者の要求（connect the two, or state the residual gap）の両方に、新規計算なし（既掲載数値のみ）で応じられる。
- 欠点: 特になし（本文 3–4 文の追加）。

**Option B: residual gap の宣言のみ**
- 接続の定量化はせず、「check は null に対する resolution の診断であり、near-null での coverage は別途 S2 が特徴づける。両者の間に smooth な遷移帯が残る」とだけ書く。
- 利点: 最小編集。
- 欠点: 手元の数値で架けられる橋を架けないのは勿体なく、R2 の「connect the two」に半分しか答えない。**A を推奨**。

### 4.4 Draft reply-letter

> We agree that the two should be connected, and the connection is quantitative in results already reported. The coverage erosion and the null floor are two faces of the same boundary phenomenon. S2's true W₁ of 2.0 sits below the null-floor mean at n = 50 (floor mean 2.46; coverage 0.703), just above it at n = 100 (1.76; coverage 0.904), and well clear of it at n = 200 (1.26; coverage 0.947): coverage degrades exactly while the true distance lies within or near the floor, and is restored as it clears it. The operability check is therefore a per-partner flag for the regime in which the erosion occurs. The residual gap the reviewer identifies is real and is now stated: the erosion is smooth while the verdict is binary, so a partner resolved by a modest margin still sits in the transition zone, and its interval should be read as approximate. In the application this concerns the six unresolved age partners — whose observed distances lie at 0.9 to 1.5 times their floor means, squarely in the S2-like zone — and the three marginally resolved ones; we now caution in Section 4.2 that their bootstrap intervals are approximate, while noting that no decision in Section 4 rests on those intervals: eligibility is a point-estimate comparison, and the unresolved flag itself is the safeguard against over-reading them.

### 4.5 編集が必要な箇所（列挙のみ）

- §2.5 L214 周辺 または §3 L447/L455 周辺: S2 と null floor 平均の 3 点対応の追記。
- §4.2 L513 周辺: unresolved / marginal-resolved partner の CI を近似として読む注意（判定層の非依存も併記）。
- Table 3 注記（L544）: 任意（cross-reference のみ）。

---

## 5. R1.1 — binary EM（secukinumab 動機例）と continuous-only scope

### 5.1 原稿の現状（tex 行番号）

- **L66**（Intro）: 「we focus on continuous effect modifiers … categorical effect modifiers raise distinct methodological considerations and are outside the present scope.」
- **L72**（Intro）: secukinumab の CRP/MRI status（binary）を動機例として使用しつつ、「That case involved a binary status, where imbalance reduces to a difference in proportions; the continuous effect modifiers on which we focus can differ in shape and spread …」と緩衝は既に張ってある。
- **L686**（Discussion）: 同じ secukinumab 例を再訪。**L688**: 「It treats continuous effect modifiers marginally, leaving categorical and multivariate extensions for future work.」

### 5.2 Binary special case の導出（検証済み）

X ∈ {0,1}、地域 r の有病割合 p_r = P(X = 1) とする。

1. **W₁ = |p₁ − p₂|**: F_r(x) = 0 (x < 0), 1 − p_r (0 ≤ x < 1), 1 (x ≥ 1)。CDF 面積形（eq. wasserstein, L131）より W₁ = ∫|F₁ − F₂| dx = |(1−p₁) − (1−p₂)| × (区間 [0,1) の長さ 1) = |p₁ − p₂|。
2. **地域平均効果差の恒等式**: τ̄_r = (1−p_r)τ(0) + p_r τ(1) = τ(0) + (τ(1) − τ(0)) p_r。ゆえに **|τ̄₁ − τ̄₂| = |τ(1) − τ(0)| · |p₁ − p₂|**。
3. **Lipschitz constant との一致**: {0,1} ⊂ ℝ 上の τ の最小 Lipschitz constant は |τ(1) − τ(0)| / |1 − 0| = |τ(1) − τ(0)|（相異なる点対が一組しかないため）。よって L = |τ(1) − τ(0)| と置けば Proposition 1 の bound |τ̄₁ − τ̄₂| ≤ L·W₁ は**等号で成立**する（2 の恒等式そのもの）。τ を ℝ 全体へ同じ定数で Lipschitz 拡張（線形補間）できるので、Proposition 1 は文言どおり適用可能。KR dual（L142）の sup を達成する関数が τ/L 自身であることに対応する。
4. **含意**: binary では Δ_max = L·W₁ は上界ではなく**厳密値** — 「subgroup 効果差 × 有病割合差」という臨床で慣用の算術に一致する。さらに R2.1(b) の slope-vs-Lipschitz gap は binary では**消滅**する（L は二点間の効果差そのもので、標準的な subgroup interaction contrast として推定可能。sup と平均の区別が生じない）。
5. **Operability check の継承**: null（p₁ = p₂ = p）下で Ŵ₁ = |p̂₁ − p̂₂|。§2.5 の resampling scheme（L212）はそのまま適用でき、漸近的には |N(0, p(1−p)(1/n₁ + 1/n₂))| の (1−α) 分位点 z_{1−α/2}·√(p(1−p)(1/n₁+1/n₂)) という閉形式もある（α = 0.05 で z = 1.96）。binomial null floor として一文で書ける。

（注意: この等号性は binary（二点台）に固有。順序カテゴリでスコアが与えられれば W₁ は定義できるが等号は一般に失われ、名義多値ではそもそも距離構造の指定が要る — そこは future work のままが正しい。）

### 5.3 Honest assessment: **partially valid — scope 文の書き方が招いた指摘で、数学は逆に有利**

指摘の前提「the method covers only continuous ones」は L66 の scope 文の文言に忠実な読解であり、責任は原稿側にある。しかし実体は「binary では方法が壊れる」のではなく「**binary では方法が退化して厳密になる**」であり、1 remark で完全に吸収できる。secukinumab 例は ICH E17 文脈での regulatory hook（PMDA workshop; L72, L686）として動機の要であり、維持すべき。

### 5.4 Response options

**Option (i)（推奨）: binary special case の short remark を追加し、scope 文を書き換える**
- §2.2 末尾（L159 の後）に Remark（5–8 行）: 上記 1–3, 5 を提示（framework 適用可、bound は等号、operability は binomial floor で継承）。L66 の scope 文は「binary は特別な場合として框組みに含まれ Proposition 1 が等号成立、方法の付加価値は shape/spread が問題になる continuous の場合にある; 名義多値・多変量は future work」に変更。L688 も「categorical」→「multi-category nominal」へ精密化。
- 利点: R1.1 を完全に解消しつつ動機例を保持。binary での等号は「W₁ 較正は既知の subgroup 算術の厳密な一般化」という位置づけを与え、R2.1(b) への回答（binary では gap が消える）とも噛み合う。追加 simulation 不要。
- 欠点: 「では ordinal/nominal は」と続く可能性（→ remark 内で一文の線引きで処理）。Intro の scope 段落と Discussion の limitation の書き換えが必要。

**Option (ii): 動機例の差し替え（continuous EM の事例に変更）**
- 利点: scope 文を触らずに済む。
- 欠点: secukinumab/Matsushima は「EM 分布差が実際に regulatory 問題を起こした」文書化事例として代替が見当たらず、E17 文脈の説得力を失う。L72 は既に binary→continuous の橋を書いており、差し替えは得るものより失うものが大きい。1 remark で済む (i) がある以上、**非推奨**。

### 5.5 Draft reply-letter

> The reviewer is right that the motivating example involves a binary effect modifier while the exposition restricts attention to continuous ones. The restriction, however, reflects where the method adds value, not where it applies — and for a binary modifier the framework does not merely apply, it becomes exact. We have added a remark stating this. For X ∈ {0,1} with regional prevalences p₁ and p₂, the area between the two distribution functions gives W₁(F₁, F₂) = |p₁ − p₂|; since τ̄_r = τ(0) + (τ(1) − τ(0))p_r, the regional effect difference is |τ̄₁ − τ̄₂| = |τ(1) − τ(0)| · |p₁ − p₂|, and |τ(1) − τ(0)| is precisely the smallest Lipschitz constant of τ on {0,1}. Proposition 1 therefore holds with equality: the calibration Δ_max = L · W₁ reduces to the familiar subgroup arithmetic of an effect contrast multiplied by a prevalence difference, with no conservatism, and the concern about average slopes versus Lipschitz constants raised elsewhere in this review does not arise, because with two support points the two coincide. The operability check carries over verbatim — under the null Ŵ₁ = |p̂₁ − p̂₂|, the same resampling scheme yields the floor, which also admits a binomial closed form. The scope sentence in the Introduction has been revised accordingly: binary modifiers are within the framework as the exact special case, the method's added value lies with continuous modifiers whose distributions can differ in spread and shape, and multi-category nominal modifiers — which require a metric on the category space that W₁ does not by itself supply — remain future work. The secukinumab example is retained: it documents the regulatory consequence of an unassessed effect-modifier imbalance, and under the added remark it now falls within, rather than outside, the framework's stated scope.

### 5.6 編集が必要な箇所（列挙のみ）

- L66（Intro）: scope 文の書き換え（binary を含む框組みへ、名義多値は future work のまま）。
- §2.2 L159 の後: binary special case の Remark 新設（W₁ = |p₁−p₂|、等号、binomial floor）。
- L72（Intro）: Remark への前方参照を一句追加（現行の緩衝文はほぼ維持可能）。
- L688（Discussion）: 「categorical … future work」→「multi-category nominal … future work」へ精密化。
- §2.5（任意）: binary の場合の floor の閉形式に触れる一文。

---

## 検証記録（Rule: 数値検証）

- 本メモの GUSTO 数値はすべて `results/gusto_operability.csv`（production; seed 20260821, B=2,000, α=0.05 one-sided — `R/gusto_operability_check.R` L38–40）と tex 本文の掲載値から取得。比率は単純除算で、代表例 R1-age: 0.646356/0.723618 = 0.893 を再掲の上、全比率を同一手順で算出。
- 追加計算（simultaneous floor q_{1−0.05/30}、seed 安定性）は `review_response/tmp_floor_sensitivity.R`（seed 20260906; B=10,000 for flip 判定対象、B=2,000 for seed 安定性）。同スクリプトの w1_obs 7 値はすべて production CSV と一致（例: R6-age 0.9121 ↔ 0.912123）。q_{1−0.05/30} は Monte Carlo 推定値であり、原稿に載せる際は production pipeline で seed 記録の上、再生成すること。
- age unresolved 6 partner の同定（R1, R4, R5, R7, R9, R15）は CSV の resolved_anchor=FALSE 行と原稿 L509 の一致を確認済み。

---

## Executive Summary（5 行）

1. **R1.2/R2.1(a) は valid**: prognostic ≤ 予言は演繹でない — L_UB を「illustrative・sponsor 責任の clinical input」に再配置し（Supplement D §0.8 と本文 L190/L563 を整合）、|τ′| ≤ |R₀′|+|R₁′| の arm-decomposition を参照関係の正確な形として明示、既存の 0.8–2× sensitivity（L602–604）を頑健性の主担ぎ手にする（Option A）。
2. **R2.1(b) も数学的に valid** だが「内部矛盾」は過大 — Prop 1 は非線形 τ で成立し、欠陥は L174 の specification 一文。平均 slope ≠ sup|τ′| を明記し、safety factor κ・部分積分の局所性（L は CDF が異なる範囲のみ押さえればよい）・形状制約下の端点識別・L* pathway（application の実経路、bound 非主張）で応答（Option A）。θ 指定 simulation は提案しない。
3. **R2.2**: 実装は α=0.05 one-sided・B=2,000・anchor-drawn resampling（per-partner、partner-drawn 感度で 30/30 verdict 一致）— Methods へ昇格。Bonferroni 型 q_{1−0.05/30} では age の marginal 3 判定（R6/R12/R14）のみ flip して unresolved 6→9、SBP 不変、選定不変 = 結論は**強化**（tmp_floor_sensitivity.R で検証済み）。L214 の「operability condition fails」は二義的で要修正。
4. **R2.4**: 橋は原稿の数値で架かる — S2 真値 2.0 の floor 平均比 0.81/1.14/1.59 ↔ coverage 0.703/0.904/0.947。check は erosion regime の per-partner flag、残余 gap（滑らかな遷移 vs 二値 verdict）は明文化し、marginal partner の CI は近似と注記（判定層は CI 非依存）。
5. **R1.1**: binary では W₁=|p₁−p₂| かつ Prop 1 が**等号**成立（L=|τ(1)−τ(0)| は最小 Lipschitz constant）、operability は binomial floor で継承 — short remark 追加＋L66 scope 文改訂で吸収し、secukinumab 例は維持（Option (i) 推奨）。
