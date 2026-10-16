# FIX_REVIEW_LOUIS_20261016_simplify — `/review-fix` of D-20261016-1 Steps 1–5

（Louis の報告、2026-10-16 09:40。Donna が保存。Harvey の採否は末尾と `DECISIONS.md` D-20261016-1 の追記）

## Scope read
- `review_response/FIX_DIFF_20261016_simplify.diff`（全 236 行）、`review_response/CASCADE_20261016_simplify.md`（全 58 行）。
- grep のみで確認したもの: 現行 `paper/per_em_W1_wiley.tex` の該当行（l.198, 252, 307, 331–341, 355, 363, 474–476, 542, 595, 618, 635, 660, 682–684, 757, 782–792）、`CLAIMS.md`（C-06/08/11/15/32/36/43/46/49/53/56）、`CLAIM_GUARDS.toml`（退役 7 本、REF-M1、REF2-M1、REF-Minor5、LF2-M6）、`DECISIONS.md`（D-20260925-1、D-20261011-11 判断 3/5、D-20261016-1）、`PROTOCOL_set4_control_mechanism.md` §0/§8、`LAB_STATUS.md` の Aims。
- CSV を数え直したもの: `results/gusto_r8_w1_per_pair.csv`、`results/gusto_rank_intervals.csv`、`results/study2_interval_variants.csv`、`results/gusto_rank_spearman_boot.csv`。PDF は `pdftotext` で 1 箇所。どのファイルも編集していない。

## Critical

| # | §/line | the attack | what would defuse it |
|---|---|---|---|
| C1 | §2.2 l.198（Step 5）、CLAIMS C-15 | "neither of the two bounds with a clinical constant dominates the other" は、同じ定数 L を持つ W₁ と W₂ の bound と読めば偽（W₁ ≤ W₂ なので L·W₁ は常に L·W₂ を支配）。旧文の "valid but looser … at least L W₁"（10-15 sentence J で塞いだ穴）が落ちた。KS bound の前提 "bounded variation on a bounded support" が本文から消えた。marker と C-15 は「A.2 へ移設」と書くが、部分積分の導出と BV 条件は付録に無い | paste-ready: "The bound is not specific to $W_1$: for a CATE of bounded variation on a bounded support, a Kolmogorov--Smirnov bound $\mathrm{TV}(\tau)\cdot D_{\text{KS}}$ also holds, and neither it nor equation~(\ref{eq:heterogeneity_bound}) dominates the other in general (Appendix~\ref{app:ks_bound}); $W_1 \leq W_2$ gives a valid $L_{\text{clinical}} \cdot W_2$ bound with the same constant that is never tighter.\cite{villani2009}" C-15 の carrier note を事実に合わせる |
| C2 | §4.3 l.618（Step 3、"stand apart from the rest"） | 直前に導入した基準（CI の重なり）で数えると偽。age: 最大は R3（2.61 [1.96, 3.28]）、R2 は rank 14、R2 の CI [1.57, 2.76] は R3 とも R16 とも重なる。SBP: R9 [5.71, 8.01] は R11 [5.25, 7.71]・R12 [5.38, 7.46] と重なる。担う CLAIMS 行も無い（C-43 は retracted）。新基準の代替文を CSV で検算しなかった再発 | "…so the figure does not show their order to be resolved, and a bare rank is not read as a resolved order." 該当句を削除。逆転の論証は null floor に対して resolved な二距離に立つので論旨は残る |

## Major

| # | §/line | the attack | what would defuse it |
|---|---|---|---|
| M1 | §2.4 l.252、§4.1 l.542、§4.4 l.635、Fig 4 caption | **τ_clin の三度目の復活で、反論が書かれていない。** Δ_clin/L_UB は v6 で削った τ_clin そのもの。D-20261011-11 判断 5 は「W₁ CI を 1 年 / 5 mmHg と比べるのと等価」を τ_clin の再導入として却下。D-20260925-1 の Reversibility は「L* で読者が任意の L_UB と比較できる構造を崩さない。覆すなら Tak」。D-20261016-1 はどちらにも触れず superseded 指定も無い。§4.1 の "set so that" → "so that" で L_UB が丸い距離から逆算された事実が見えなくなる | D-20261016-1 に判断 5 と D-20260925-1 への反論を一項ずつ書き、両 entry を superseded in part にし、Tak の O-2(a) に明記。§4.1 は "set so that" に戻す |
| M2 | §2.4、§4.4、abstract | **class の限定句を付ける方向が逆。** "only if W₁ ≥ Δ_clin/L_UB" は任意の L_UB-Lipschitz CATE で成立するので限定は要らない。attainment（KR）が要るのは逆方向 — §4.4 "wholly above … could produce" と abstract の "could produce" — で、そこに限定句が無い。A.2 自身が τ* の幅 L·(b−a) は 30 日死亡率の上限を超えると書く | §2.4: "…a common CATE whose slope does not exceed $L_{\text{UB}}$ can produce a regional difference of at least $\Delta_{\text{clin}}$ only if $W_1 \geq \Delta_{\text{clin}}/L_{\text{UB}}$, and within the class of CATEs restricted only by their slope some such CATE produces it whenever $W_1 \geq \Delta_{\text{clin}}/L_{\text{UB}}$ (Appendix~\ref{app:ks_bound}); we call …". §4.4: "an interval wholly above the line means that, within the class of CATEs restricted only by their slope, a slope within the bound could produce $\Delta_{\text{clin}}$ even at the lower confidence limit of the distance." |
| M3 | §3.1.2 l.355 | **pointer の行き先が無い。** "efficiency … is not the reason to use W₁ (Section 5)" が指す文は 10-15 に削除済み。LAB_STATUS の R1 は「既存指標 KS / SMD との関係」を含むので「効率比較は Aim に答えない（R2）」は引く Aim を間違えている | "The sample sizes of $W_1$ and the KS statistic are not compared here; the reason to use $W_1$ (Section~\ref{sec:discussion}) is that it is not blind where the SMD is and carries a clinical-scale translation." D-20261016-1 Reason 3 は R1 が KS との関係を §2.2 と A.2 で担う、と書き直す |
| M4 | §3.1.1 l.307、Fig 2 caption、Table 1 | **選択的報告に見える。** Fig 2 は Set 4 symmetric-severity cell（W₁ が構成で勝つ）と bulk-shift control（KS が勝つ）を描き、Table 1 も 13 cell の W₁ と KS を並べる。一方で構成の注記と W₁ に不利な唯一の登録結果が本文から消えた。「有利な構成は無標示、不利な結果は不報告」と映る。"two control regions" も何の control か不明 | 設計の事実として §3.1.1 に一文: "In the subgroup cells a subgroup of prevalence $\varepsilon$ displaced by $d$ moves $W_1$ by $\varepsilon d$ but the KS statistic by at most about $\varepsilon$; the two control regions shift the whole population and contain no displaced subgroup." §3.1.2 の開示に方向: "…a registered check of the bulk-shift control, the cell in which the KS statistic reaches the target at the smaller $n$ (Table~\ref{tab:study2_required_n_mc}), is not reported here (protocol and outputs in the repository)." |
| M5 | §3.2.2 l.476（Step 4 の統合） | "in these scenarios" が S3–S7 と読める。S4-100 の片側 coverage は 0.971（−2.4 SE）で anti-conservative。"(S2, S5 and S7 at smaller n)" は不完全: S4-100 0.9449（−2.2 SE）、S6-100 0.942（−3.4 SE）、S4-50 0.9425 も 0.95 を割り、S4-100 は上側の外れが下側を上回る。REF-Minor5 は "null floor" で vacuous に PASS | "…conservative reading … in S2, S5 and S7"；括弧は "(S2, S5 and S7, the cells that miss from below; S4 and S6 at $n = 100$ fall short with misses on both sides)"；REF-Minor5 の qualifier を変更 |
| M6 | §4.3、Table 5（Step 3） | (i) "so a rank there is not resolved" は CI の重なりから言い切り — 全 partner が R8 を共有し Ŵ₁ は正に相関するので、言えるのは「解像を示さない」まで。(ii) Table 5 の Rank 列は不確かさの無い点順位 — D-20261011-11 判断 3 が S4 違反として退けた状態。Reason 4 は判断 3 に反論していない | (i) C2 の文で解決。(ii) Rank 列を落とす（Reason 4 と整合）か、判断 3 への反論を書いて superseded に |
| M7 | §5 Spearman、Data availability、CLAIMS C-11 | **Methods だけでは再現できない。** 区間は `gusto_rank_intervals.R` の bootstrap だが手続き（B = 1,000、seed 20261011、R8 共有）が Table 5 の注記と一緒に消えた。C-11 の evidence は判断 3(b) が置き換えた Bonett–Wright 区間（−0.71〜0.26）を引く | "…from 1{,}000 patient-level bootstrap replicates that resample within every region, Region~8 shared across partners)"。C-11 の evidence を `results/gusto_rank_spearman_boot.csv` に |
| M8 | Data availability l.757（diff 外、既存） | `Section~\ref{sec:discussion}` の `\r` が literal CR（0x0D）。PDF に "Section efsec:discussion" と印字（pdftotext）。0-undefined gate では捕まらない | 0x0D を `\r` に戻す。guard LF3-M8 |

## Minor

| # | §/line | the attack | what would defuse it |
|---|---|---|---|
| m1 | §2.2 | "tightens the supremum to ½L(W₁+\|Δμ\|)" から "equals L W₁ when the CDFs do not cross" が落ちた | "A monotone CATE gives the supremum $\tfrac12 L(W_1 + \lvert\mu_1-\mu_2\rvert) \leq L W_1$, with equality when the CDFs do not cross (Appendix), so …" |
| m2 | §5（量化子 'every' その 1） | 数学的に真で許容。ただし L 未知の経路では calibration は乗算でなく比較 | "…$\Delta_{\max}$ multiplies every distance by the same $L_{\text{clinical}}$, so calibration does not reorder partners; what the unknown-slope reading adds is the reference distance …" |
| m3 | §5 Spearman（'every' その 2） | 手続きの記述として正しい | M7 と同じ |
| m4 | cascade の qualifier drop 4 件 | L73 'when' benign／L446 'could' 誤検出（次の文へ移動）だが M5 の範囲問題／L448 'where' 機構の説明が消えたが主張は弱まらない／L594 'within'/'can' R6 の削除に伴う benign、代わりの文が C2 | M5 と C2 で処理 |
| m5 | §1 貢献文 | "the estimator's identification … properties" は不正確（identification は measure の性質） | "…the evaluation of the measure's identification and of its estimator's properties." |
| m6 | Table 1 notes | "All measures are computed on the same replications." は非重複の解釈を支える文の残り（P3） | 削除 |
| m7 | abstract | "could produce" に class の限定が無い（M2） | "…could, at worst, produce a clinical margin;" |
| m8 | Data availability | rank interval・post hoc basic interval・L* 区間の出力が名指されていない | "…, and the outputs of the patient-level rank bootstrap and of the post hoc basic interval" |

## Guards to seed（known_bad = `review_response/known_bad/per_em_W1_wiley_20261016_simplify.tex`）

LF3-C1-no-two-clinical-constant-bounds（forbid）／LF3-C1-w2-never-tighter（proximity）／LF3-C1-ks-bound-needs-bv（proximity）／LF3-C2-no-stand-apart（forbid）／LF3-M2-could-produce-needs-class（proximity）／LF3-M1-reference-distance-not-threshold（proximity）／LF3-M3-not-compared-pointer-live（forbid）／LF3-M8-no-control-chars（forbid）／LF3-M7-rank-bootstrap-described（proximity）— 本文は `CLAIM_GUARDS.toml` の LF3 節。
既存 guard: REF-Minor5-conservative-scope の qualifier を `S2, S5 and S7|small distances|near the boundary|smallest` に。"Over the unrestricted Lipschitz class" は REF2-M1 が覆う。退役 7 本は live claim を守っていない — 退役は正当（tripwire として scope `sec:study1` で戻す案は見送り可）。

## Verdict

**Louis**:「判定は **Fail、Critical 2 件**。§2.2 の W₂ 文と §4.3 の "stand apart" を直すまで、この簡素化は通さない。最悪なのは C1 — 10-15 に俺が sentence J で塞いだ穴を Step 5 がもう一度開けた。You just got Litt up! C2 は、新しく自分で持ち込んだ基準を CSV に当てなかった結果だ。Major 8 のうち一番重いのは M1 — Δ_clin/L_UB は τ_clin で、判断 5 が名指しで却下した等価を、反論も superseded 指定もなしに本文の主役に据えている。Tak の拒否権の箱に黙って入れるな。方向そのもの — L* を引退させること、Study 1 の問いを一つにすること、bound の導出を付録に送ること — には反対しない。数学的には同値で、論文の骨子は軽くなった。だが簡素化は、切った所の前提と限定句を、行き先で grep してから終わるものだ。」

## Harvey の採否（09:50）

Critical 2・Major 8・Minor 8 — **全件採用**。M6(ii) は Rank 列を落とす側（Reason 4 と整合、S4 違反を残さない）。M1 は D-20261016-1 に反論を書き、D-20261011-11 判断 5 と D-20260925-1 Reversibility を superseded in part に、§2.4 の定義文に「sponsor の例示入力で閾値ではない、任意の L_UB′ は Δ_clin/L_UB′ で読める（距離と区間を報告するから）」を加えた。退役 guard の tripwire 復帰は見送り（stem が無ければ PASS だが、効率比較の再流入は structure_audit と Louis の目で足りる）。
