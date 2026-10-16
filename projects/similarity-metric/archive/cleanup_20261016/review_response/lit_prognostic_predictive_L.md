# Annotated Bibliography: Prognostic-vs-Predictive & Registry-Generalizability (Review Response Support)

**Compiled**: 2026-09-06 (Rachel Zane, Researcher)
**Purpose**: Support the authors' response to two simulated *Statistics in Medicine* reviewer criticisms of the per-EM $W_1$ manuscript (`paper/per_em_W1_wiley.tex`):

> **Criticism 1**: "A prognostic gradient describes baseline risk, not treatment-effect modification; using Lee's prognostic age slope to bound CATE sensitivity does not follow."
>
> **Criticism 2**: "Registry/RWE distributions differ from trial-enrolled populations through eligibility and enrollment selection; a $W_1$ computed from registry data may misstate similarity of enrolled populations."

All DOIs below were verified against publisher/PubMed records via web search on 2026-09-06 (per Rule 2.6). No entry is unverified; no 🔍 flags required.

---

## (A) Supplement D Gap Assessment (`paper/supplement_L_clinical_lit.md`)

### A.1 Against Criticism 1 — partially covered, but the load-bearing step is asserted without literature

**What it covers:**

- Supplement D **does already acknowledge the prognostic-vs-modifying gap**, twice:
  - §0.5 (Lee 1995 entry) caveat: *"Main effects, not interactions. Substituting prognostic slope for modifying slope is conservative but not exact."*
  - §0.8 transparency note: *"No published source provides a directly-tabulated $L_{\text{clinical,age}}$ … or $L_{\text{clinical,SBP}}$ … The v2 paper acknowledges this explicitly and frames the bounds as illustrative class-level."* It also names the proper remedy (GUSTO-I IPD re-analysis with treatment × EM interaction terms via Fisher 2017's deft approach).
- It carries the two empirical premises of a valid defense, without assembling them: FTT 1994's finding that the **proportional (relative-scale) reduction is approximately constant** across age/SBP strata (§0.1), and Lee 1995's **baseline-risk gradients** (~6×10⁻³/yr age, ~1–2×10⁻³/mmHg SBP; §0.5).

**Where it is vulnerable / silent:**

1. **The ceiling claim is asserted as if it were a general law.** §0.7/§0.8 state *"a treatment effect cannot vary across an EM faster than baseline risk varies"* — with no citation and no stated condition. As an unconditional claim this is **false**, and the reviewer is right to attack it: a purely *predictive* covariate can have a flat prognostic gradient and a steep interaction gradient (the standard counterexample in the biomarker literature, e.g. KRAS status; Ballman 2015, Clark 2008). The valid version is conditional: on the absolute-risk scale, with $ARR(x) = (1 - RR(x))\,r_0(x)$,
   $$\frac{\partial ARR}{\partial x} = (1 - RR(x))\, r_0'(x) \;-\; r_0(x)\, RR'(x),$$
   so the prognostic gradient $r_0'(x)$ bounds the CATE slope **only when the relative effect is approximately constant in $x$** ($RR'(x) \approx 0$) — which for AMI thrombolysis on age and SBP is exactly what FTT 1994 reports empirically. Supplement D never writes this decomposition, and never cites the risk-magnification literature (Glasziou & Irwig 1995; Kent et al. 2016/2018/2020) that makes the conditional argument standard and citable. Note the conditional argument is *stronger* than the current wording: with $RR \approx 0.82$ (FTT), the first term is $\approx 0.18 \times r_0'(x)$, so $L_{\text{UB}} = 1.5\times$ the prognostic gradient is conservative by nearly an order of magnitude, not by 50%.
2. **The prognostic/predictive terminology never appears.** The canonical distinction literature (Ballman 2015; Clark 2008; PATH statement) is entirely absent from Supplement D and from the .bib. A response that does not first *concede the taxonomy in the reviewer's own vocabulary* will read as not understanding the objection.
3. **The condition under which the ceiling argument would fail is not stated** (a near-pure predictive EM with flat prognosis). For age and SBP in AMI this failure mode is excluded empirically by FTT's relative-effect constancy — but the manuscript must say so explicitly rather than leave it implicit.
4. Its estimation-methodology arm (riley2010, fisher2017) predates the current standard; **Riley et al. 2020 (Stat Med)** is the up-to-date recommendation paper for treatment-covariate interaction estimation and is published in the target journal.

### A.2 Against Criticism 2 — essentially silent

- The **only** adjacent content is §5.4 (Tipton generalizability, flagged as "adjacent but not $L_{\text{clinical}}$", suggested for one Discussion sentence). There is **nothing** on eligibility/enrollment selection, trial-vs-registry population differences, or transport of covariate distributions.
- Meanwhile the manuscript actively claims the exposure: the abstract says $W_1$ "can be computed from any representative data source, including prior trials, disease registries, and real-world evidence (RWE) databases," and the Discussion policy paragraph (near line 686) repeats it citing only ICH E6(R3), with no supporting citation and no limitation about selection into trials. **Criticism 2 currently has no answer anywhere in the paper or supplement.**

---

## (B) Existing .bib Coverage Assessment (`paper/per_em_W1_wiley.bib`)

| Key | Cited in .tex? | What it DOES support | What it does NOT support |
|---|---|---|---|
| `vanderweele2014`, `vanderweele2019` | Yes (Methods, def. of interaction slope) | Definition and scale-dependence of the interaction slope; interaction-continuum interpretation | Say nothing about *inferring or bounding* an interaction slope from a **prognostic** model — do not answer Criticism 1 |
| `vanderweele2009` | **In .bib but uncited** | Distinction between *interaction* and *effect modification* (two causal contrasts) | That is a different distinction from prognostic-vs-predictive; citing it as the answer would miss the reviewer's point |
| `riley2010`, `fisher2017` | Yes (Methods; Suppl. D) | How $L$ *should* be estimated (IPD meta-regression; within-trial "deft" interactions) — the "proper remedy" arm of the response | The bounding logic itself; also predate current recommendations (see Riley 2020 below) |
| `ftt1994` | Yes (Methods, Application) | **Load-bearing premise (i)**: proportional reduction ~constant across age/SBP strata in AMI thrombolysis (i.e. $RR'(x)\approx 0$) | Currently cited only as generic "class-level evidence"; the relative-effect-constancy premise is never named as the condition that licenses the ceiling |
| `lee1995` | Yes (Methods, Application) | **Premise (ii)**: baseline-risk gradients $r_0'(x)$ in the GUSTO-I cohort itself | On its own, exactly what the reviewer says: prognosis, not modification |
| `gusto1993` | Yes | Case-study population; categorical subgroup contrasts | Continuous interaction slopes |
| `pearl2011`, `bareinboim2016` | **In .bib but uncited in current .tex** | Formal transportability (selection diagrams, S-admissibility) — re-activatable for Criticism 2 as the theoretical frame | Graph-theoretic; SiM reviewers will expect the operational epi/biostat literature (Westreich, Dahabreh) and disease-area empirical evidence (Steg) alongside |
| `austin2011` | Yes (Intro/Existing) | Propensity-score adjustment for confounding | Trial-enrollment selection / generalizability is a different problem |

**Bottom line**: the .bib has the *estimation-methodology* leg (riley2010/fisher2017) and both *empirical premises* (ftt1994, lee1995) of the Criticism-1 defense, but not the *taxonomy* (Ballman/PATH) nor the *risk-magnification bridge* (Glasziou–Irwig/Kent). For Criticism 2 it has only dormant formal-transportability entries and no empirical or operational literature.

---

## (C) New References

### C-1. For Criticism 1 (prognostic vs predictive; bounding the CATE slope)

**1. Ballman KV (2015) "Biomarker: Predictive or Prognostic?" *Journal of Clinical Oncology* 33(33):3968–3971 DOI: [10.1200/JCO.2015.63.3651](https://doi.org/10.1200/JCO.2015.63.3651)**
The canonical short statement of the prognostic/predictive taxonomy: a prognostic marker is associated with outcome regardless of treatment; a predictive marker is one on which the treatment effect depends, demonstrable only with randomized comparison; a marker can be both. Cite it to *concede the reviewer's premise in the reviewer's vocabulary* — Lee 1995 is indeed prognostic — before showing that the manuscript never treats it as predictive but uses it as a conditional ceiling. Where: Methods §2 ($L_{\text{UB}}$ paragraph, near line 190 of the .tex) and a new Supplement D subsection ("prognostic gradients as conditional ceilings"); first paragraph of the response letter.
*(Alternate with the same content, verified: Clark GM (2008) "Prognostic factors versus predictive factors: Examples from a clinical trial of erlotinib" *Molecular Oncology* 1(4):406–412 DOI: [10.1016/j.molonc.2007.12.001](https://doi.org/10.1016/j.molonc.2007.12.001) — a worked RCT example showing covariates that look predictive but are merely prognostic; use if a non-oncology-editorial, worked-example citation is preferred.)*

**2. Kent DM, Paulus JK, van Klaveren D, et al. (2020) "The Predictive Approaches to Treatment effect Heterogeneity (PATH) Statement" *Annals of Internal Medicine* 172(1):35–45 DOI: [10.7326/M18-3667](https://doi.org/10.7326/M18-3667)** (companion Explanation & Elaboration: DOI: [10.7326/M18-3668](https://doi.org/10.7326/M18-3668))
The consensus statement distinguishing *risk modeling* from *effect modeling*, and codifying **risk magnification**: because absolute benefit is mathematically tied to baseline risk, a prognostic gradient generates a gradient in absolute treatment effect even with no relative-scale effect modification. This is the authoritative modern source for the claim the reviewer says "does not follow" — on the absolute (30-day mortality) scale used for $\Delta_{\max}$, baseline-risk gradients and CATE gradients are *not* unrelated quantities. Where: Methods §2 alongside Ballman; Supplement D new subsection; response letter core argument.

**3. Glasziou PP, Irwig LM (1995) "An evidence based approach to individualising treatment" *BMJ* 311(7016):1356–1359 DOI: [10.1136/bmj.311.7016.1356](https://doi.org/10.1136/bmj.311.7016.1356)**
The classic formalization: under an approximately constant relative risk, absolute benefit is proportional to baseline risk, $ARR(x) = (1-RR)\,r_0(x)$, so $\partial ARR/\partial x = (1-RR)\,r_0'(x) \le r_0'(x)$. This supplies the *algebraic bridge* from Lee's prognostic slope to an upper bound on the absolute-scale CATE slope — the exact step Supplement D asserts without citation — and shows the bound is conservative by the factor $(1-RR)\approx 0.18$ given FTT's overall proportional reduction. Where: Methods §2 ("conservative" sentence, line ~190) and Application §4 (line ~563); the decomposition itself belongs in Supplement D.

**4. Kent DM, Nelson J, Dahabreh IJ, Rothwell PM, Altman DG, Hayward RA (2016) "Risk and treatment effect heterogeneity: re-analysis of individual participant data from 32 large clinical trials" *International Journal of Epidemiology* 45(6):2075–2088 DOI: [10.1093/ije/dyw118](https://doi.org/10.1093/ije/dyw118)**
Large-scale empirical demonstration that "risk of the outcome is a mathematical determinant of the absolute treatment benefit" and that within-trial variation in absolute benefit is dominated by the baseline-risk gradient. Rebuts the implicit claim in Criticism 1 that prognostic gradients are *uninformative* about treatment-effect variation: across 32 trials they are its primary reproducible driver on the absolute scale. Where: Supplement D new subsection (empirical support); optionally one clause in Discussion.

**5. Riley RD, Debray TPA, Fisher D, et al. (2020) "Individual participant data meta-analysis to examine interactions between treatment effect and participant-level covariates: Statistical recommendations for conduct and planning" *Statistics in Medicine* 39(15):2115–2137 DOI: [10.1002/sim.8516](https://doi.org/10.1002/sim.8516)**
The current-standard recommendations for estimating treatment-covariate interaction slopes: estimate interactions directly, use within-trial information only, keep continuous covariates continuous, examine non-linearity. Strengthens the response's constructive arm — "the proper estimate of $L_{\text{clinical}}$ is an IPD interaction re-analysis, and here is the current standard for doing it" — updating riley2010/fisher2017, and it is in the target journal. Where: Methods §2 (line ~174, alongside `riley2010`/`fisher2017`) and Supplement D §0.8.

### C-2. For Criticism 2 (registry/RWE vs trial-enrolled populations; generalizability/transportability)

**6. Steg PG, López-Sendón J, Lopez de Sa E, et al. (2007) "External Validity of Clinical Trials in Acute Myocardial Infarction" *Archives of Internal Medicine* 167(1):68–73 DOI: [10.1001/archinte.167.1.68](https://doi.org/10.1001/archinte.167.1.68)**
GRACE-registry comparison of 8,469 AMI patients: RCT participants were systematically lower-risk than eligible-but-not-enrolled and ineligible registry patients, with lower mortality. This is the reviewer's empirical premise, demonstrated *in the manuscript's own disease area* — cite it to concede the selection phenomenon precisely, then delimit what it does and does not imply for a between-region $W_1$ comparison computed on a common source type. Where: new limitation sentence(s) in Discussion (near lines 686–688); response letter.

**7. Rothwell PM (2005) "External validity of randomised controlled trials: 'To whom do the results of this trial apply?'" *Lancet* 365(9453):82–93 DOI: [10.1016/S0140-6736(04)17670-8](https://doi.org/10.1016/S0140-6736(04)17670-8)**
The canonical taxonomy of external-validity threats: setting, eligibility criteria, run-in periods, enrollment/consent selection. Provides the standard vocabulary ("eligibility and enrollment selection") in which the response can frame both the concession and the mitigation. Where: Discussion limitation paragraph; response letter framing.

**8. Kennedy-Martin T, Curtis S, Faries D, Robinson S, Johnston J (2015) "A literature review on the representativeness of randomized controlled trial samples and implications for the external validity of trial results" *Trials* 16:495 DOI: [10.1186/s13063-015-1023-4](https://doi.org/10.1186/s13063-015-1023-4)**
Systematic review: 71% of representativeness studies concluded RCT samples were not broadly representative, with frequent exclusion of elderly and comorbid patients — directly relevant because **age is one of the two case-study EMs**, and age is exactly the axis on which enrollment selection is best documented. Supports quantifying the *direction* of the concern (registry age distributions shifted right of trial distributions). Where: Discussion limitation sentence; Supplement D or a response-letter footnote.

**9. Westreich D, Edwards JK, Lesko CR, Stuart E, Cole SR (2017) "Transportability of Trial Results Using Inverse Odds of Sampling Weights" *American Journal of Epidemiology* 186(8):1010–1014 DOI: [10.1093/aje/kwx164](https://doi.org/10.1093/aje/kwx164)**
Operationalizes transport between trial and target populations via inverse-odds-of-sampling weights on the covariates governing selection. Constructive mitigation for Criticism 2: when enrollment selection on an EM is a concern, the registry distribution can be reweighted toward the enrolled (or target) population *before* computing $W_1$ — the framework composes with, rather than conflicts with, the transportability machinery. Also reconnects the dormant `pearl2011`/`bareinboim2016` entries to an operational method. Where: Discussion (policy paragraph + future work); response letter.

**10. Dahabreh IJ, Robertson SE, Steingrimsson JA, Stuart EA, Hernán MA (2020) "Extending inferences from a randomized trial to a new target population" *Statistics in Medicine* 39(14):1999–2014 DOI: [10.1002/sim.8426](https://doi.org/10.1002/sim.8426)**
Outcome-model, participation-probability, and doubly robust estimators for extending trial inferences to a target population characterized by baseline covariate data — the same evidentiary configuration as the manuscript's planning scenario (trial-external baseline distributions). Citable both as the formal statement that *effect-modifier selection into trials* is what breaks naive transport (the reviewer's mechanism) and as the standard remedy; published in the target journal. Where: Discussion; response letter.

---

## (D) Synthesis（応答の最強引用チェーン）

### Criticism 1 への応答チェーン

**構造: 譲歩 → 条件付き上界の明示 → 保守性の定量 → 本来推定への導線。**

1. **譲歩（taxonomy を先に自分から認める）**: Lee 1995 は prognostic model である — Ballman 2015（必要なら Clark 2008）の用語でその通り。論文は Lee の slope を $L_{\text{clinical}}$ の**点推定**として使っていない。使っているのは **ceiling（上界のanchor）**としてのみ。
2. **条件付き上界の明示（ここが現行原稿と Supplement D に欠けている一手）**: 絶対リスクスケールでは $ARR(x) = (1-RR(x))\,r_0(x)$、したがって
   $\partial ARR/\partial x = (1-RR)\,r_0'(x) - r_0(x)\,RR'(x)$。
   - 前提 (i): FTT 1994 — proportional reduction は age/SBP 層でほぼ一定（$RR' \approx 0$、relative-scale interaction の実証的排除）。**既存 cite の ftt1994 をこの前提として明示的に再引用する。**
   - 前提 (ii): Lee 1995 — $r_0'(x)$（prognostic gradient）。
   - 橋渡し: Glasziou & Irwig 1995（constant-RR framework）+ PATH statement（risk magnification の現代的定式化）+ Kent 2016 IJE（32試験の実証）。
3. **保守性の定量**: FTT の $RR \approx 0.82$ の下では CATE slope $\approx 0.18 \times r_0'(x)$。よって $L_{\text{UB}} = 1.5\times$ prognostic gradient は「およそ一桁」保守的であり、reviewer の懸念する方向（過小な bound）とは逆に働く。さらに bound sensitivity 解析（§4, ±factor scan）が既に原稿にある。
4. **本来推定への導線**: 厳密な $L_{\text{clinical}}$ は GUSTO-I IPD の treatment × EM interaction 再解析によるべき — fisher2017 (deft) + **Riley 2020 (Stat Med, 10.1002/sim.8516)** を現行標準として追加。Supplement D §0.8 の記述と完全整合。

**原稿修正の最小セット**: Methods line ~190 と Application line ~563 の "exceeding the empirical prognostic gradient" の文に「FTT の relative-effect near-constancy を条件とする conditional ceiling」であることを一文で明示し、Ballman + PATH + Glasziou–Irwig を cite。Supplement D に上記の分解を含む短い新節を追加。

### Criticism 2 への応答チェーン

**構造: 選択の実在を譲歩 → estimand の明確化 → 構成的緩和策 → limitation 明記。**

1. **譲歩**: enrollment selection は実在し、AMI 領域そのもので実証済み — Steg 2007（GRACE: 登録試験患者は registry 患者より低リスク）、一般論として Rothwell 2005、系統的レビューとして Kennedy-Martin 2015（高齢者除外 = 本論文の EM である age に直結）。
2. **estimand の明確化**: 本 framework の planning-stage estimand は「地域の患者集団の EM 分布の類似性」。registry が地域患者集団を代表するなら、registry ベースの $W_1$ は *target-population similarity* をそのまま測る。enrolled-population への言明に読み替えるには、選択機構が比較対象の両地域で同様に働く（selection が region と独立）という追加仮定が必要で、これは明示すべき仮定である。
3. **構成的緩和策**: 選択が EM 上で起こると懸念される場合、inverse-odds-of-sampling weights（Westreich 2017）や participation-probability / doubly robust モデル（Dahabreh 2020）で registry 分布を enrolled/target 集団へ再重み付けした上で $W_1$ を計算できる — framework は transportability 機構と**合成可能**。形式的基盤として休眠中の `pearl2011`/`bareinboim2016` を .tex に再活性化する選択肢もある。
4. **limitation 明記**: Discussion の policy 段落（line ~686、RWE 主張）に、eligibility/enrollment selection による分布の乖離と上記仮定・緩和策を1–2文で追記し、Steg + Rothwell（+ Westreich or Dahabreh）を cite。これで abstract の "any representative data source" の "representative" が定義された語になる。

---

*Compiled per Rule 2.6 (all DOIs verified 2026-09-06). This file is bibliography support only — no edits made to the .tex, .bib, or Supplement D.*
