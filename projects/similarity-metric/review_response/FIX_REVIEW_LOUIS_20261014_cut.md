# FIX_REVIEW_LOUIS_20261014_cut — /review-fix: 本文削減 D-20261014-1

- Before: `paper/backup/length_cut_20261014/per_em_W1_wiley_pre_cut_20261014.tex`（11,097 語）
- After: `paper/per_em_W1_wiley.tex`（9,461 語、834 行）。行番号はすべて After のもの
- Mechanical pass: `scripts/cascade_check.py`（137 changed / 72 added / residue 4 / qualifier drop 17 / quantifier 3）
- 照合したもの: `log6.json`（75 行）の old/new 全件、`CLAIMS.md`、`LENGTH_CUT_20261014.md`、`DECISIONS.md` D-20261014-1、`PROTOCOL_study2_extension.md`、`numbers_registry.csv`
- Louis は read-only。原稿は変更していない

**Louis**:「判定。削った語数は立派だ。だが自分で決めた規則 (2)『10-12/13 の訂正文は切らない』を、拒否権の marker を付けた cut 2 本が破っている。M12（"the reason to prefer … is not sharpness but the constant"）と D01（Discussion ¶1 の MCSE count と SD scope）だ。M04 の caveat の A.3 移設は D-20261014-1 が認めた手段なので違反ではない。だが本文に残った句から L の条件が落ちた（K6）。最悪は M12 だ。あの文が消えたせいで、L209 の "Neither bound dominates the other in general" が monotone bound と Δ_max の直後に宙吊りになった。素直に読めば『Lipschitz bound と monotone bound はどちらも他方を支配しない』という主張になり、これは偽だ（monotone の sup は常に ≤ L W₁）。さらに L154 は今も sharpness を W₁ 採用の三つの理由の一つに挙げている。KS も同じく sharp だと断る文が §2.2 から消えたので、『KR duality で W₁ は構成上最適』という循環攻撃の扉が半分開いた。二番目は H1 と D08 だ。この 2 本は互いの log を見ずに切ったので、『effect modifier をどう選ぶかは範囲外』という文が本文から一つ残らず消えた。三番目は D01 だ。10-12 に俺が入れさせた Discussion ¶1 の MCSE count を切り、L668 の marker を偽にした。CLAIMS 行で唯一の担い手を失ったものは無い。そこは認める。だが carrier が残っても、限定句と pointer がこれだけ壊れていれば reviewer は見つける。You just got Litt up!」

## Findings

| ID | Line | Finding | Severity | Minimal fix |
|---|---|---|---|---|
| K1 | L209（M05 + M12） | "Neither bound dominates the other in general (Appendix A.3)" の先行詞が消えた。cut 前は KS bound との比較文（M12）の直後にあった。今は eq.(mono_bound) と「Δ_max is a conservative upper bound」の直後にあるので、自然な先行詞は Lipschitz bound と monotone bound になる。monotone class は Lipschitz class の部分集合だから sup は常に ≤ L W₁ で、その読みでは偽の数学的主張になる（P4） | Major | "Neither the $W_1$ bound nor the Kolmogorov--Smirnov bound dominates the other in general (Appendix A.3)." と主語を名指す |
| K2 | L208 marker / L154 / L201 | M12 の削除は REF M1（10-12）と Louis round 3 M8/M14（10-13）の訂正文の削除で、規則 (2) 違反。L154 は sharpness を「採用の三つの理由」の三つ目に挙げたままだが、§2.2 にはもう「sharpness は KS も自分の class で持つので区別にならない。区別するのは定数だ」と言う文が無い。L201 の "likewise sharp" と "property of the class" は半分しか守っていない。§5 L698 末尾が「理由は定数」を担っているが、Methods の読者はそこまで読まない。KR 循環攻撃が再び開く | Major | M12 を 1 句で復元（+≈20 語）: "Sharpness, which the Kolmogorov--Smirnov bound also has within its class, does not distinguish the two bounds; the constant does: $L_{\text{clinical}}$ is a per-unit slope, whereas $\mathrm{TV}(\tau)$ is clinically stated only for a monotone CATE." |
| K3 | L671（D01）、L668 marker | Discussion ¶1 から coverage の範囲、"below 0.95 beyond Monte Carlo error in k of the ten cells"、"about x–y SD" が消え、pointer だけが残った。L668 の revision comment は、10-12 の Louis M1/M9 でこの段落に MCSE count を carry させたと記録している。俺自身の fix を切ったことになり、規則 (2) 違反だ。残った "the coverage range … are reported there" は中身の無い pointer で、P3 の対象。L668 の marker も今は偽 | Major | D01 を revert するか、最低限 "Its estimation is characterized by Study 2: coverage below 0.95 beyond Monte Carlo error in \numval{nCellsCovBelow2MCSE} of ten cells for true distances of about \numval{minW1SdS3toS7}–\numval{maxW1SdS3toS7} SD (Section 3.2.2)." を残す |
| K4 | L73–74（H1）+ L734（D08） | 二重削除。H1 は「framework は sponsor が指定する候補 EM に作用し、候補がどう同定されたかは問わない」を、D08 は「どの baseline 特性が EM かの同定は interaction の証拠を要する上流の問題」を消した。log の H1 行自身が "scope statement is lost" と書き、D08 行は H1 を見ていない。prose を grep すると upstream / sponsor specifies / prognosis alone は 0 件。reviewer の「なぜ age と SBP か、誰が EM を選ぶのか」に答える文が無い（仮定の欠落） | Major | 1 句復元（≈30 語）。§1 末尾か §5 limitations に "The framework operates on whichever candidate effect modifiers the sponsor specifies; identifying them requires evidence on treatment-by-covariate interaction rather than on prognosis (Section 2.4) and is outside the present scope." |
| K5 | L323（S17、C-28 retracted） | log-scale SMD の結果（Set 2 shape cell で AUC 1.00、combined で 0.51）が本文から消え、数値は表にも無い。しかも SMD に有利な結果だ。C-07 / abstract の「SMD は 7/13 cell で blind」には Set 2 shape cell が入っている。省略理由の "the paper compares distribution-level measures with the single-summary SMD" は、log-SMD 自体が single-summary SMD なので当てはまらない。cherry-picking 攻撃（「log 変換すれば済む」）への pre-empt を自分で外した | Major | 1 句復元: "SMD computed on the log scale in the log-normal world (which recovers the shape contrast but leaves the combined cell at chance)"。または C-07 と abstract を "raw-scale SMD" に narrow し、省略理由を log-SMD に合うよう書き直す。C-28 の retract は D-20261014-1 で再審 |
| K6 | L209（M04）、L804 | "over the recorded supports of Section 4 the attaining τ* would require effects beyond the baseline risks" が L を指定していない。registry によれば `lipRangeAge` / `lipRangeSbp` は L_UB × pooled range で計算されている。L が小さければ成り立たないので、無条件の overclaim（qualifier drop: cascade §3 L161 の 'up to'）。A.3 の移設文も "L_clinical (b−a) … is lipRangeAge" と書くだけで、L = L_UB を言っていない | Major | §2.2: "…at the illustrative bounds $L_{\text{UB}}$ of Section 2.4 the attaining τ* would require…"。A.3: "with $L_{\text{clinical}} = L_{\text{UB}}$" を挿入 |
| K7 | L804 / L274（H7 + M04 の移設） | 移設で back-pointer が壊れた。(a) A.3 は "(20.5% above 75 years; Section 2.4)" と書くが、H7 の後の §2.4 に 20.5% は無い。(b) 6.5×10⁻³ は §2.4 が "Appendix A.3" を指し、A.3 末尾が "(Section 2.4)" を指し返す冗長な相互参照になった（両側とも lee1995 を引いているので、無出典ではない）。(c) A.3 内で 20.5% を、それを導入する 1.1%/20.5% の文より一文先に使っている。(d) "tightens … further" の比較対象（eq. mono_bound）と τ* の定義（§2.2）が A.3 から辿れない。moved text は self-contained でない | Major | A.3 の Lee 文を先に置き、二つの "(Section 2.4)" を消して lee1995 を直接引く。"τ* of Section 2.2"、"further than equation (mono_bound)" を補う |
| K8 | CLAIMS.md C-09, C-32 Evidence 欄 | 削除済みの `paper/generated/tab_coverage.tex`・`tab_bias.tex`・`tab_precision.tex` を証拠として引いたまま。ディスクに無い evidence pointer は §12 の Major。C-32 の "Tables 4 and 6"、凡例の "Tables 3–6 = Study 2" も stale | Major | `tab_estimation.tex`（Table 3）に repoint し、凡例の表番号を compiled の番号に直す |
| K9 | L496（H5）/ L503–504 Table 5 note（cut 前から存在） | "the three cells at the application's operating point as an amendment" は誤り。protocol §9（l.138–149）の amendment は E5・E6・E3c で、E3c は S3 の整数格子 n = 1,000（0.5 SD）なので operating point ではない。note は E5/E6 の 2 cell だけを operating point と書いていて、本文の "three" と数が合わない。cut 前からある誤りだが、H5 はこの段落を書き換えたのに残した。prior-look / registration の開示文が事実と違う | Major | "…and three further cells (the two at the application's operating point and the integer-grid cell at $n = 1{,}000$) as an amendment registered before those cells ran"。note も同じ数え方に |
| m1 | L426（S19） | "…and 200 per region, We performed 10,000 replications…"。cut が comma splice + 大文字 W を残した。build も guard も捕まえない | Minor | "…per region. We performed…" |
| m2 | L729（D06） | "the same holds for an $L_{\text{clinical}}$ taken from an estimated average interaction slope" で、独立した limitation（推定 slope は定数の下界なので、そのまま使うと bound が anti-conservative になりうる）が「conditional on it」の一例に格下げされた。limitations が 3→2 になり、意味が変わった（単なる圧縮ではない） | Minor | Second を独立文に戻す: "An $L_{\text{clinical}}$ taken from an estimated average interaction slope is a lower bound on the Lipschitz constant, so a bound computed from it can understate the difference; the safety factor of Section 2.4 is not supplied by the framework." |
| m3 | L729（D07、C-21 の唯一の担い手） | limitations 段落から "it assumes the CATE varies with that modifier alone" が落ちた。仮定の名指しが Prop. 1 と abstract にしか残らない。"the bound is per effect modifier:" の直後に additive の場合が来るので、per-modifier bound が additivity の下でそのまま成り立つかのように読める | Minor | "Finally, the bound is per effect modifier, assuming the CATE depends on that modifier alone: for a CATE additive…"（+7 語） |
| m4 | L575（H2b）、A05/H2a 削除 | anchor を null の source に選ぶ理由（partner のデータが anchor に情報を与えるときに適切な null）が消えた。"so the anchor-resampled floor is retained" が、二つの source の一致だけを根拠にした結論になった。§2.3 も理由を言わない。68 語の一文 | Minor | 一句復元: "…retained as the display reference, being the null appropriate when the partner's data are to inform the anchor." |
| m5 | L698（D04） | "the location-only limitation of SMD is structural and the lack of a clinical scale is addressed by…"。W₁ が三つの limitation のどれにどう答えるかの並列が崩れ、"structural" の根拠（Study 1）がこの段落から消えた。"this does not mean…" の this の先行詞も曖昧。65 語 | Minor | "…is structural (Study 1, Section 3.1.2)…; addressing these limitations does not mean…" |
| m6 | L355（S04） | 例（"In the symmetric-severity cell, for example"）が一般文より先に来る。同じ値を `reqnW1Set4symsevB` と `reqnW1Set4symsev` で一文に二度出している。"ranges across the task" は意味が曖昧 | Minor | 順序を入れ替える: "$W_1$'s requirement ranges from … to … across the cells of Sets 3 and 4; within one cell, symmetric severity, the KS statistic needs … , a …-fold difference" |
| m7 | L784（H6） | Jensen の導出が見出し "Non-negativity and Identity of Indiscernibles" の下に置かれ、見出しと内容が合わない | Minor | 見出しを "Non-negativity, Identity of Indiscernibles and Upward Bias" に |
| m8 | L274 / L656（A13） | A13 の削除で、prose に残った L_UB の値は §2.4 の "≈ 1×10⁻²" と "≈ 2×10⁻³" だけになった。Table 9 note は "="。queue #36 で "approximately" を外した経緯（10%pt per decade ちょうど）と矛盾する | Minor | §2.4 を "= 1×10⁻² per year (10%pt per decade)" と "= 2×10⁻³ per mmHg" に揃える |
| m9 | L479（S22） | S1 coverage 段落から "at F₁ = F₂ the naive bootstrap is not consistent" が落ちた（queue #23 で入れた引用点）。§2.3 と A.2 が担うので許容範囲だが、log の "R2d" 分類は甘い | Minor | 現状維持でよい。LENGTH_CUT に担い手（§2.3 L229、A.2 L796）を明記 |
| m10 | P1 長文（item 5） | merge で長くなった文の worst 5: L628（A08、99 語 — 最悪。3 文を 1 文に）、L229（M08、79 語）、L575（H2b、68 語）、L729（D06、67 語）、L698（D04、65 語）。次点は L457（S21、64）と L280（M11、62）。結論が理由より先に来る段落: L575（理由を消したまま "so … retained"）、L355（例が先）、L671（pointer で終わる） | Minor | L628 は "…can move. A mid-table rank is not resolved…: R6 … . The most distant partners, R2 on age and R9 on SBP, …" の 3 文に。他は ; で分けている箇所を文に |
| m11 | `R/study1_summary_exact.R` l.229/239/248 | 今も `tab:bias` / `tab:coverage` / `tab:precision` のラベルで行を書いている stale writer | Minor | ラベルを `tab:estimation` に直すか、writer を退役させる |
| m12 | cascade §2 residue 4 行 | 4 行とも削除文の意図された生存先（L161 の SMD 対比、abstract の coverage、L290 の Study 2 estimand、L400 の Table 2 文）。だが DECISIONS.md D-20261014-1 にも LENGTH_CUT にも理由の記録が無い。俺の規則では、記録が無ければ finding だ | Minor | LENGTH_CUT §3 に「residue 4 行 = 意図された carrier」の 1 行を足す |
| m13 | L272 marker（M17） | "Alternative specification strategies include the deft estimator of Fisher et al." が消えた。fisher2017 は L247 に残るが、L_UB 指定の代替手段の pointer が無くなった | Minor | 許容。reviewer に聞かれたら L247 で答える |

### cascade_check の各行の処分（俺の担当 §2–§4）
- **§4 quantifier 3 件はすべて false positive**: L126 の "all three" は old にもあった（"satisfy all three requirements"）。L536 の "every distance" は old の A05 "leaves every distance on the same side of its 95th percentile" から来たもの。L627 の "in every dataset" も old に "returning a different answer in every dataset" とある
- **§3 qualifier drop 17 件**: L161 の 'up to' は **K6**。L635 の 'when' は **m3**。L627 の 'mean-matched' は **m5**。L412 の 'where'（S13）は `missAboveMaxS2S5S7pct` = 1.1% < 2.5% で、S2/S5/S7 は全 n で miss-from-below なので、広げた "in S2, S5 and S7" は支えられている（defused）。残る 13 件（L68, L76, L126, L159, L163, L200, L227, L319, L406, L416, L560, L621, L623）は限定句の移設か接続詞の言い換えで、主張は強まっていない。L560 の "within each panel" は Fig. 3 caption、L623 の "within each region" は Table 8 note に残る
- **§2 residue 4 件**: **m12**

### 規則 (2) の点検 — 10-12/13 の訂正文
| 訂正 | 状態 |
|---|---|
| attainment → sharpness（KR、class の性質） | L201 に残る。ただし M12 が消えた → **K1/K2** |
| monotone bound eq.(mono_bound) と GUSTO の比 | L201–209、L646 に残る |
| collapsibility | L122、L717 に残る |
| Jensen の命題 | L234 に命題、A.1（L784）に導出。見出し → **m7** |
| Study 1 scope（selection、k supplied、ranking by effect difference ではない） | L290、L328 に残る |
| Set 4 control の mechanism（protocol の license の範囲内） | L355 に残る（MCSE 付き、prior look の開示付き） |
| coverage S5/S7 vs S6/S4-100 | L468 に残る |
| upper limit / basic interval（post hoc と明記） | L482、Table 4 note に残る |
| outliers / heaping / permutation（post hoc） | L555、L575 に残る |
| extension E5/E6 | L496、L594 に残る。amendment の数 → **K9** |
| Lee / GUSTO の数値 | 6.3/7.2/7.4 は L274 に残る。1.1/20.5/19.4 は A.3 へ → **K7** |
| positioning の引用（shen2018, redko2017, stuart2011, tipton2014, dahabreh2020, munk1998） | L83 に全部残る |
| Discussion ¶1 の MCSE count と SD scope（10-12 M1/M9） | **切られた → K3** |
| bounded / unbounded-support caveat（REF2 M1 / EXT Minor 2） | A.3 へ移設。本文の残りの句は無条件 → **K6** |

### CLAIMS（item 1）
- supported/narrowed の行（C-02, 03, 06, 07, 08, 09, 10, 11, 16, 17, 23, 32, 33, 35, 37, 40, 42, 49、加えて C-05, 45, 46, 47, 48）はすべて carrier が残っている
- 弱くなった carrier: C-09（Discussion から MCSE count が消えた → K3）、C-16（sharpness の但し書きが §2.2 から消えた → K2）、C-05（L が無条件 → K6）、C-21（仮定の名指し → m3）、C-40（省略理由が log-SMD に合わない → K5）、C-12（anchor source の理由 → m4）
- dead evidence: C-09 と C-32 → K8

### 数値と引用（item 2）
- prose から消えた `
umval` key は 16。14 は Table 3（covS3–S7 の範囲、covS2n50note、covS5n50note）か Table 8（w1AgeR3/R5/R6、w1SbpR2/R6/R9、ciLo/HiSbpR6）にある。どの表にも無いのは `aucSMDlogShapeN2000` と `aucSMDlogCombinedN2000` だけ → K5
- 消えた引用 key は無い。回数が減ったのは iche17（5→3）、komiyama2024（4→2）、fisher2017（2→1）。lee1995 は 2→3
- Monte Carlo SE の文はすべて残っている（L426、L482、L496、L355 の SE、Table 2 caption、Table 5 note）。dropped hedge は K6・m3 のほか、"post hoc"・"not pre-specified"・"equal n"・"normal reference"・"three by construction"・prior-look 句はすべて生存（L355、L482、L496、L555、L698、L717、abstract）

### 表の統合（item 6）
- `\ref{tab:bias|coverage|precision}` は原稿に 0 件、生成器は旧 3 ファイルを unlink している。Table 3 の caption と note は bias・coverage（S1 = 0 の理由）・RMSE・width の定義、σ = 10、10,000 reps / B = 2,000 を持つ
- 旧 coverage note の「S1 は表から省略」は、S1 を表に入れたので正しく消えた。旧 note の S4 範囲と S2/S5 の n = 50 値は L471 に残る。旧 3 note から claim が必要とするもので失われたものは無い
- Table 5: cell list を note に移した。"E5 small distance" / "E6 … rounded" のラベルは note と一致する。amendment の数 → K9

### CLAIM_GUARDS.toml への提案（Major ごと。known_bad = 現在の `paper/per_em_W1_wiley.tex`（cut 後）。どれも cut 前ファイルでは PASS、cut 後では FAIL することを確認してから strict に入れること。cut 後で PASS する guard は vacuous）
1. K1 — type `cooccur`: stem "Neither bound dominates" または "neither … dominates" の文は "Kolmogorov" か "W_1" を同じ文に含むこと。scope §2.2
2. K2 — type `presence`: §2.2 に "does not distinguish" / "not sharpness" のどちらかがあること。scope `sec:nabcd_metric`
3. K3 — type `count`: `\numval{nCellsCovBelow2MCSE}` が abstract の外に 2 回以上（§3.2.2 と §5）
4. K4 — type `presence`: "outside the present scope" と "effect modifiers the sponsor specifies"（または "identifying them"）が本文にあること
5. K5 — type `cooccur`: "SMD computed on the log scale" があるなら、"recovers" か `aucSMDlogShapeN2000` が同じ文にあること
6. K6 — type `qualifier`: stem "attaining" + "baseline risks" の文は "L_{\text{UB}}" か "illustrative bound" を含むこと
7. K7 — type `xref`: A.3 の中に `Section~\ref{sec:inference}` を数値の出典として置かない（`20.5\%` / `6.5 \times 10^{-3}` と同じ括弧内に出たら FAIL）
8. K9 — type `forbidden`: "three cells at the application's operating point"（cut 前からある誤りなので、known_bad には cut 前ファイルも入れる。cut 前で PASS する必要は無い）

### 次に reviewer が聞くこと（pre-empt）
- 「§2.2 は sharpness を採用理由に挙げるが、KS も sharp だ。結局 KR duality の言い換えではないか」→ K2 の 1 句で答える
- 「age と SBP は誰が選んだのか。outcome Lasso は prognostic factor を選ぶ」→ K4 の 1 句で答える
- 「SMD は log 変換すれば Set 2 shape は解けるのではないか」→ K5 で、本文に結果を戻して答える

## Counts
- Critical 0 / Major 9（うち cut 前から 1: K9）/ Minor 13
- 規則 (2) 違反: 2（M12、D01）。どちらも拒否権 marker 付きの cut。M04 の A.3 移設は D-20261014-1 が認めた手段なので違反に数えない（K6 は qualifier drop として残る）。拒否権は Tak のものだが、規則違反を報告するのは俺の仕事だ
- 新しい recurring pattern（memory には書いていない。今回の write は本ファイルだけ）: (a) 移設 cut が back-pointer を循環させる（"moved verbatim" の文が移設元を出典として指したまま）。(b) 二つの cut がそれぞれ「もう一方が担う」と仮定して、唯一の担い手を同時に消す（H1 + D08）

**Louis**:「9,461 語にしたこと自体は評価する。だが K1–K7 の修正はどれも 1 句、合計 +150 語ほどで済む。9,600 語で穴の無い原稿と、9,461 語で reviewer に三つの攻撃口を渡す原稿。どちらを出すかは考えるまでもない。」
