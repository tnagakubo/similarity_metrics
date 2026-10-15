# FIX REVIEW — Louis — D-20261015-2（骨子からの絞り込み、図を戻して文章を切る）

- 対象: OLD = `review_response/known_bad/per_em_W1_wiley_pre_D-20261015-2.tex` → NEW = `paper/per_em_W1_wiley.tex`（行番号は NEW）
- 入力: diff、cascade report `review_response/FIX_REVIEW_20261015_essence.md`、CSV（`results/w1_raw_summary.csv`, `results/study1_miss_side.csv`, `results/required_n_selection.csv`, `results/set4_*.csv`, `results/gusto_r8_w1_per_pair.csv`, `results/gusto_lstar_intervals.csv`）、`PROTOCOL_set4_control_mechanism.md` §2、`CLAIMS.md`、`DECISIONS.md` D-20261015-1/-2、`CLAIM_GUARDS.toml`
- Read-only。原稿・CLAIMS・DECISIONS・SUITS は触っていない
- Tak が決めたこと（図は残す、L* 表は削る、長さを切る）は再審しない

---

**Louis**:「判定。今回の cut で偽になった文はない。§4.4 の三分類の向きは代数的に正しいし、Discussion ¶1 の "in every cell" も CSV で 13/13 だ。だが一番まずいのはそこじゃない。**図に読ませると言って文章を切ったせいで、数字の付いた証拠が四か所で消えた。その証拠に乗っていた文だけが残っている。**
① L710 の Limitations は "where the bias is large relative to the sampling standard deviation … (Section 3.2.2)" と §3.2.2 を根拠に指しているのに、§3.2.2 に残っていた唯一の担い手（bias/SD の限定句）を今回切った。しかも残った説明は "whose CDFs cross" だけで、これは 10-12 に俺が C2 で潰した説明だ。S6 も CDF が交差するのに名目近くを覆っているんだからな。
② L586 の "the extension cells at this operating point" は、0.03–0.30 SD の GUSTO 距離全体を 0.2 SD の E5/E6 が覆っているように読める。今朝の俺の訂正 (c) が守っていた句（"in places above the 0.2 SD of S2"）が消えた。
③ L363 の Set 4 check は "left … unchanged" と "reversed the sign" をどちらも MCSE なしで書いている。数字が残ったのは W₁ 側の 1.62 (0.04) だけで、protocol §2 の判定基準（各 2 MCSE 超）は読者から見えない。
④ basic interval の文は D-20261015-1 の保険リストに入っていた。DECISIONS D-20261015-2 は『保険文はすべて残す』と書きながらそれを切っていて、切った理由の『どの claim にも使われていない』は CLAIMS C-56 の本文と矛盾する。決定記録が事実と違う。
加えて L363 の "where the two AUC curves cross near the target" は、AUC 0.8 側が MC 誤差で分離していない（W₁ 204 [188, 220]、KS 184 [164, 206]）のに交差を言い切っている。今回の cut で強くなった主張はこれ一つだ。CLAIMS は narrowing がログにしか書かれておらず、Claim 列は消えた文言のままだ。図を戻したのは正しい。だが図が見せない数字を一緒に捨てたのは雑だ。直しはどれも一句で済む。You just got Litt up!」

---

## (a)–(f) への個別回答（要約）

| 問 | 判定 | 根拠 |
|---|---|---|
| (a) §3.2.2 の null-coverage 段落 | 偽はない。"at most 1.1% … at any sample size (never in S2)" は `study1_miss_side.csv` の `miss_above` で S2 は 0、S5/S7 の最大は 0.0113（S7-200）。"misses fall on both sides" も S6-100 は 0.0316/0.0263、S4-100 は 0.0261/0.0290 で真。**ただし bias/SD の限定句を落としたことで、§3.2.2 の対比を担うのが "whose CDFs cross" だけになった → M1** | CSV |
| (b) Set 4 clause | license 内。因果動詞なし、一般化なし。δ=2/3 のどちらでも n=200 で符号は反転する（gauss +0.029/+0.026、mix −0.032/−0.031）ので、"two-unit" を落としても license 違反にはならない。**ただし MCSE なし・数字の非対称 → M3** | `set4_control_mechanism.csv`, `set4_null_sd_ratios.csv`（KS 比 0.996, SE 0.019） |
| (c) §4.4 の写像 | **三つとも正しい**。L* = Δ/W₁ は減少関数なので、W₁,U < Δ/L_UB ⇔ Δ/W₁,U = L*_L > L_UB（区間が線より下 ⇔ L* 区間が L_UB より上）。W₁,L > Δ/L_UB ⇔ L*_U < L_UB。含む場合も同値。NEW には R7（SBP 5.07 [4.03, 6.22]）、R1†（age 上限 1.035）、R1 の SBP（上限 4.93）を名指す文がない → 図と矛盾する文もない。**ただし図だけでは線のそばの区間を判別できない → M6** | `gusto_r8_w1_per_pair.csv`, `gusto_lstar_intervals.csv` |
| (d) Discussion ¶1 | 支持される。W₁ は閾値 0.9 に 13/13 cell で到達（最大 690、shape_sym）。SMD が blind の 7 cell は平均一致の cell で、L340 の母集団論証と整合。"examined" が落ちた → m1 | `required_n_selection.csv` |
| (e) L* 表の削除 | 原稿内で `lstarSbpLowerR1` を必要とする文は残っていない。**CLAIMS C-36 の Claim 列は "(R1's SBP lower limit, 0.00203, …)" と Table 10 を持ったまま → M5** | `CLAIMS.md` l.57 |
| (f) §2.4 → §4.1 の移動 | §2.4 は L_UB を記号で定義している（L262）ので、dangling な参照はない。ただし L515（§3.2.2）が "the illustrative bound $L_{\text{UB,age}} = 0.01$/yr of the GUSTO-I application" を、数値が定義される §4.1（L548）より前に、節番号なしで使っている → m3 | — |

---

## Critical

なし。今回の cut で偽になった文は見つからなかった（M2 と M4 は Critical の一歩手前だ）。

## Major

| # | NEW 行 | 現在の文（抜粋） | 攻撃 | 最小修正（一文、Harvey が決める） |
|---|---|---|---|---|
| M1 | L473 + L710 | L473 "The shortfall is largest in S5 and S7, whose CDFs cross; there the intervals lie above the true value, in line with the upward bias of Section 2.3, whereas in S6 and in S4 at $n = 100$ the shortfall is small and the misses fall on both sides." ／ L710 "undercoverage near the boundary and where the bias is large relative to the sampling standard deviation … (Section~\ref{sec:sim_results})" | (i) L710 の限定句は §3.2.2 を根拠に指しているが、§3.2.2 の担い手（"whose bias relative to the sampling standard deviation of Ŵ₁ is smaller or within Monte Carlo error"）を今回切った。証拠が消えたのに claim は narrow されていない（C1 cascade）。(ii) 残った対比の軸は "whose CDFs cross" だけになったが、S6 も CDF が交差するのに 0.942 を覆っている。逆に S2 は交差しない純粋な location shift なのに 0.703（n=50）だ。10-12 C2 で外した説明が言い換えで戻った。CSV では bias/SD が S5-100 0.38 → 0.917、S7-100 0.24 → 0.935、S6-100 0.11 → 0.942、S4-100 ≈0 → 0.945 で、こちらが実際に順序を分けている | L473: "…whereas in S6 and in S4 at $n = 100$, where the bias is smaller relative to the sampling standard deviation of $\widehat{W}_1$, the shortfall is small and the misses fall on both sides."（約 14 語。L710 の担い手も同時に戻る） |
| M2 | L586 | "…the extension cells at this operating point (Table~\ref{tab:study2_ext}) gave percentile coverage \numval{covExtE5} and \numval{covExtE6} and upper-limit coverage …" | "this operating point" の先行詞は直前の "The GUSTO-I distances are gustoDistSdMin–gustoDistSdMax SD" だが、E5/E6 は 0.2 SD の一点だけだ。GUSTO の距離は 0.03–0.30 SD で、30 組中 6 組は 0.2 SD を超える（`results/derived/gusto_dist_sd.csv`）。今朝の俺の Critical (c) で直した句（"and in places above the 0.2 SD of S2"）がまた落ちた。読者は extension が GUSTO の範囲全体を覆うと読む | "…the extension cells at 0.2 SD, the application's operating point (Table~\ref{tab:study2_ext}), gave percentile coverage …"（3 語） |
| M3 | L363 | "…found that at $n = 200$ per region the Set 4 anchor population multiplied the null sampling standard deviation of $\widehat{W}_1$ by \numval{set4NullSdRatioW1n200} (Monte Carlo SE …) relative to $N(50, 10^2)$, left that of the distribution-free KS statistic unchanged, and reversed the sign of the paired AUC difference between the two measures." | "unchanged" と "reversed the sign" はどちらも simulation の方向語で、推定値も MCSE も付いていない（S-rule 違反: 性能指標に MCSE なし）。protocol §2 がこの文を許す条件（ΔAUC が各 anchor で 2 MCSE 超、abs(ρ_KS − 1) ≤ 2 MCSE）を読者が確かめられない。W₁ 側の数字だけ残して KS 側と ΔAUC を落とすのは、外から見れば選択報告だ。数字は全部 registry にある（`set4NullSdRatioKSn200`、`set4DeltaAuc*N200d2` とその Mcse） | "…left that of the distribution-free KS statistic unchanged (\numval{set4NullSdRatioKSn200}, SE \numval{set4NullSdRatioKSn200Mcse}), and reversed the sign of the paired AUC difference, from \numval{set4DeltaAucGaussN200d2} (SE …) under $N(50, 10^2)$ to \numval{set4DeltaAucMixN200d2} (SE …)."（約 20 語。`PROTOCOL_set4_control_mechanism.md` §8 Deviations（O-7）は未記入のまま） |
| M4 | L488（削除箇所）／DECISIONS D-20261015-2 | 削除: "A bias-corrected (basic) interval, examined post hoc, covered … and exceeded the percentile interval only under S1 and in S2 at $n = 50$ …" | (i) この文は D-20261015-1 の保険リストに入っている（DECISIONS l.412「basic interval の 1 文」）。D-20261015-2 は「残した保険文: A・B・C-prime・D-prime・I・J と survey の向き … すべて残す」と書くが、basic interval の文は切られ、C-prime も KS 比の数字を失った（M3）。**決定記録が事実と違う。** (ii) 削除理由の「どの claim にも使われていない」は、Claim 列に basic interval の句を持つ CLAIMS C-56 と矛盾する。(iii) EXT M4(c)（basic/BCa との比較）への回答が本文から消えた。SiM の referee は境界近くで "why percentile, not basic/BCa?" と必ず聞く。Methods は Wald との比較しか書いていない | L488 の末尾に: "A basic interval, examined post hoc, exceeded the percentile interval's coverage only under S1 and in S2 at $n = 50$ (repository)."（約 22 語、数値なし、`study2_interval_variants.csv` と整合）。あわせて DECISIONS D-20261015-2「残した保険文」の行を訂正 |
| M5 | `CLAIMS.md` l.29 / 38 / 46 / 57 / 66 / 70 / 77 | C-08, C-25, C-36, C-49 は「narrowed」とログ（l.137）に書かれているが、**Claim 列は旧文言のまま**だ: C-08 は "(333 [318, 348] vs 377 …)" と "at AUC 0.95 … at 0.8 …"、C-25 は "Lee … 6.5×10⁻³"、C-36 は "(R1's SBP lower limit, 0.00203 …)" と Table 10、C-49 は "1.00 (MCSE 0.02)" と "+0.029 → −0.032" と "wording unchanged" の status。C-45（"For the enrolled samples the bound holds exactly"、L228 で削除）と C-56（basic interval、L488 で削除）は「担い手のみ更新」に分類されているが、実際は主張そのものを失っている | 台帳が原稿に存在しない主張を "supported" と宣言している。`/claims check` と `evidence_coverage.py` はこの Claim 列を読むので、四つ目の目が空振りする。C-45 の enrolled-sample 句は EXT Minor 1（D-20261012-3 で採用）への回答で、それが 72 時間以内に理由の記録なしで覆った | Donna: 7 行の Claim 列を原稿の現行文に narrow し、C-45/C-56 を narrowed に分類し直す。D-20261015-2 の CLAIMS 行に「EXT Minor 1 の回答を撤回」と理由を書く（ログの C-32 の担い手 "Table 6" も誤り。estimation は Table 3） |
| M6 | L639 + L601（Fig. 3 caption） | L639 "…on the $W_1$ scale of Figure~\ref{fig:gusto_forest} this is the position of each interval relative to the reference line at $\Delta_{\text{clin}} / L_{\text{UB}}$." | (i) §4.4 は三つのケースを定義するだけで、どの partner がどこに入るかを一文も書いていない。R4（読み方の例示）の結論が図に丸投げされている。(ii) その図は線のそばの区間を判別できない。R1† の age 上限 1.035 年と線 1 年（†なので上限だけで読む partner で、判定が 0.035 年で変わる）、R1 の SBP 上限 4.93 mmHg と線 5（旧表の注が名指していたまさにその case）、R7 の age 0.945、R5 の age 0.92。Table 5 は 2 dp で判別できるが、L639 は Table 5 を指していない。(iii) W₁ 軸に縦線を引けば、referee（と規制当局）は pooling の閾値として読む。これは EXT M5 が提案した同等性検定「W₁,U < Δ_clin/L_UB で棄却」そのものだ。しかも L_UB は "set so that one year of age or 5 mmHg … would reach a margin of 1 percentage point"（L548）なので、線の位置は設計者が選んだ 1 年 / 5 mmHg を言い直したものにすぎない。昔その選択を外部の数値（Lee の予後勾配 ≤ 6.5×10⁻³/yr）に繋いでいた句は今回消えた | L639 に一句: "…relative to the reference line at $\Delta_{\text{clin}} / L_{\text{UB}}$, whose limits are given in Table~\ref{tab:gusto_nabcd} where they lie close to it." Fig. 3 caption の末尾に: "The line depends on the sponsor's illustrative bound and is not a threshold for pooling."（caption 規則とも両立する。何を描いたかの定義であって解釈ではない） |
| M7 | L363 | "…and overlap in \numval{nCellsOverlap}, the shape-symmetric mixture, where the two AUC curves cross near the target." | 交差を言い切るには、AUC 0.8 で KS が先、0.95 で W₁ が先という両方が要る。0.95 は分離している（W₁ [1152, 1246] vs KS [1263, 1379]）が、0.8 は重なっている（W₁ 204 [188, 220] vs KS 184 [164, 206]）。旧文は "at AUC 0.8 the point estimates favour the KS statistic and the intervals overlap" と書いて交差を点推定の話に留めていた。cut はその限定句を落とし、"cross" だけを残した（compression drops the qualifier、俺の常連パターンだ）。Fig. 2 は shape_sym を描いていないので、原稿の中に証拠がない | "…and overlap in \numval{nCellsOverlap}, the shape-symmetric mixture."（句を削るだけ。表の注 "overlap does not show equal performance" が残る） |

## Minor

| # | NEW 行 | 現在の文（抜粋） | 攻撃 | 最小修正 |
|---|---|---|---|---|
| m1 | L655 | "in Study 1 the SMD is at chance at every sample size in the mean-matched cells" | "examined" が落ちた。"in Study 1" と言う以上、grid（≤ 2,000）の外を主張できるのは L340 の母集団論証だけで、ここはその論証を引いていない。"in every cell" も、KS が同じく 13/13 で到達することを言わないので、要件 (i) が W₁ を選ぶ理由に読める（¶3 の "like the KS statistic" まで読まないと分からない） | "…at every sample size examined in the mean-matched cells, whereas $W_1$, like the KS statistic, reaches the discrimination target in every cell." |
| m2 | L473 | "Near the boundary, S2 and S5 undercovered at $n = 50$ (\numval{covS2n50} and \numval{covS5n50})." | S5 を "near the boundary" に入れ直している。旧文は S2 だけに付けていた。S5 は 0.4 SD で、L586・L655・L710 では "S3–S7, about 0.4 to 1.2 SD" の非境界側に入っている。自分の分類と矛盾する。しかも n=50 では S7（0.929）も 2 MCSE を超えて下回る | "At $n = 50$, coverage was lowest in S2, near the boundary, and in S5 (\numval{covS2n50} and \numval{covS5n50})." |
| m3 | L515 | "For S3 on the age scale with the illustrative bound $L_{\text{UB,age}} = 0.01$/yr of the GUSTO-I application, … the 1\%pt margin used in Section~\ref{sec:app_clinical}" | 移動の副作用。数値の定義は §4.1（L548）で、ここより後にある。節番号もない。margin の出所を §4.4 と指しているが、設定しているのは §4.1 だ | "…$L_{\text{UB,age}} = 0.01$/yr of the GUSTO-I application (Section~\ref{sec:app_scenario})…" と、margin の pointer を `sec:app_scenario` に |
| m4 | L548 | "the FTT meta-analysis\cite{ftt1994} and the GUSTO-I prognostic model\cite{lee1995} are reference points, not sources of the bounds." | 何の reference point なのかが本文から消えた（6.5×10⁻³/yr の比較を削除）。lee1995 の中身は付録 L788（20.5% above 75）にしかない。`/cite-check` が照合できる passage がこの文には無い（S7）。§2.4 L275 の "A prognostic gradient alone guarantees no bound…" も、何を限定しているのかが見えなくなった | 句を削る（"…of 1 percentage point." で終える）か、"…; Lee et al.'s age-specific mortality is a reference point (Appendix~\ref{app:ks_bound})" とする |
| m5 | L445 | "Bias is positive and largest under the null (S1: …)" | 普遍文に読める。S4 の n=100 は点推定 −0.013 で（MC 誤差 0.014 以内、理論上は ≥ 0）、Fig. 2A に負の棒が見える。読者は図と文が矛盾すると思う | "Under the null the bias is largest (S1: …)"、または "Bias is non-negative in expectation and largest under the null" |
| m6 | L435 / L473 | "\numval{mcseBoundProp}"（Design）と "(at most \numval{mcseBoundPropB})"（Results） | 同じ MCSE の上限を二つの key で二度書いている（P3） | L473 の括弧を削る（Design の文が全体を覆っている） |
| m7 | L449（Fig. 2 caption） | "S1 coverage is structurally zero because the true value lies at the parameter space boundary" | caption 規則（何を描いたかだけ、解釈は書かない）違反。理由は表の注と L483 にある | "S1 coverage is zero by construction (Section~\ref{sec:sim_results})." |
| m8 | — | 選択報告: Study 1 の目標依存 | 0.8 / 0.95 の tally が本文から消えた。L332 の "the reported target is the middle of the three examined" だけが残る。CSV で数えると W₁ が分離して少ない cell は 0.8 で 10、0.9 で 11、0.95 で 12 なので、報告した目標は W₁ に有利な方向に選ばれてはいない。開示は形式上足りている。ただ referee は "does 11/13 depend on the target?" と聞く | 任意: L332 に "(the counts below change by one cell at the other two targets; repository)" |
| m9 | — | 数の不一致 | brief は numbers 110/110、DECISIONS D-20261015-2 は `numbers_audit` 111/111 と書いている | Donna が再実測して一つに揃える |

## 選択報告（問 2）— 1 文開示の基準（Harvey 条件 ②）

| 登録研究 | NEW の開示 | 判定 |
|---|---|---|
| Set 4 control check | L363（protocol、prior look の開示、repository） | 形式上は満たす。**内容は M3 で欠ける**（KS 比と ΔAUC に推定値も MCSE もない）。protocol §8 Deviations は未記入（O-7） |
| Study 2 extension | L496 + Table 4（全 11 行）＋ L503 の注（登録の経緯） | 満たす。ただし L586 の橋は M2 |
| Real-data survey | L686（向き + Spearman の範囲 + repository） | 満たす。Data availability との矛盾（O-10）は今回の cut の前からあるもので、持ち越し |
| Study 1 の不報告解析 | L325 | 満たす |
| basic interval（post hoc、EXT M4(c) への回答） | **なし** | M4。登録研究ではないが、保険として約束した文で、外部レビューへの回答でもあった |

## OLD が先回りしていて NEW では referee が突く点（問 3）

| 攻撃 | 旧文（OLD） | 評価 |
|---|---|---|
| "Why percentile, not basic/BCa, near the boundary?" | OLD l.471 basic interval の文 | Major（M4） |
| "What drives the undercoverage? S6 crosses too." | OLD l.458 "whose bias relative to the sampling standard deviation …" | Major（M1） |
| "Does your operating-point extension cover the GUSTO range?" | OLD "and in places above the 0.2 SD of S2" | Major（M2） |
| "Show the Set 4 reversal with its uncertainty." | OLD l.354 の KS 比と ΔAUC（SE 付き） | Major（M3） |
| "Is the shape-symmetric crossing real?" | OLD l.357 "at AUC 0.8 the point estimates favour … intervals overlap" | Major（M7） |
| "Where is R1? Your line is a pooling threshold." | OLD L* 表 + 注 "R1's SBP lower limit … just above L_UB,SBP" | Major（M6） |
| "Does the bound hold for the enrolled patients?" | OLD l.225 enrolled-sample 文（EXT Minor 1） | Minor（理論上は自明だが、外部レビューへの回答が消えた。M5 で台帳側として扱う） |
| "Why 1e-2 per year? Arbitrary." | OLD l.269 Lee の予後勾配との比較 | Minor（m4。M6 (iii) と連動） |
| "Do the Study 1 required n transfer to GUSTO-I?" | OLD "Study 1's required sample sizes … do not transfer" | Minor。L586 の operating-point の橋で答えが付いているので、削除は許容できる。ただし M2 を直すことが前提 |

## 提案 guard（`CLAIM_GUARDS.toml`、known_bad = 現行 NEW の作業ツリー。修正前の現行 NEW で FAIL しない guard は vacuous）

| id 案 | type | pattern / stem + qualifier | scope | 備考 |
|---|---|---|---|---|
| LF2-M1-coverage-axis-not-crossing | proximity | stem "whose CDFs cross"、qualifier "bias is smaller relative to the sampling standard deviation" または "bias relative to the sampling standard deviation" | §3.2.2 | 現行 NEW で FAIL（限定句がない）。10-12 C2 の再発防止 |
| LF2-M2-extension-at-0.2SD | proximity | stem "extension cells at"、qualifier "0.2 SD" | §4.2 | 現行 NEW で FAIL |
| LF2-M3-set4-with-mcse | proximity | stem "reversed the sign of the paired AUC"、qualifier "set4DeltaAuc" | §3.1.3 | 現行 NEW で FAIL。`set4NullSdRatioKSn200` についても同じ型を一本 |
| LF2-M7-no-unresolved-crossing | forbid | "AUC curves cross near the target" | §3.1.3 | 現行 NEW で FAIL |
| LF2-m2-S5-not-boundary | forbid | "Near the boundary, S2 and S5" | §3.2.2 | 現行 NEW で FAIL |
| LF2-M6-line-not-threshold | proximity | stem "The dotted vertical line marks"、qualifier "not a threshold" | Fig. 3 caption | 現行 NEW で FAIL |

---

**Louis**:「一行判定: 偽の文はなく、Critical なし。ただし Major 7 件、どれも一句で直る。M1–M4（消えた担い手、橋、MCSE、保険の撤回と虚偽の決定記録）を直して CLAIMS の Claim 列を narrow するまで、この cut は commit に値しない。」
