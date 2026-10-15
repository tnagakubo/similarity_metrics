# ESSENCE SKELETON — per_em_W1_wiley.tex（2026-10-15 07:30、Harvey、D-20261015-2）

Tak の指示（verbatim）: 「図の削減は愚策ではないか？図によって文章が削減できる部分もあるだろう。内容として無駄な部分、主張に関連しない部分があるはずだ。論文の骨子から見直して本当に必須な本質的部分に絞れ」

判定の物差しは `LAB_STATUS.md` の骨子だけ: **A1** 効果修飾因子の分布の類似性を定量的に評価する指標を提示する → **R1** 定義と性質（$W_1$、Prop. 1、$L^*$）／**R2** 盲目でない（Study 1）／**R3** 推定量と bootstrap 区間の性能（Study 2）／**R4** 読み方の例示（GUSTO-I）。どの R にも答えない文は切る。図が文章を代替できる所は図を戻して文章を切る。

## 1. 図表の判定（昨日の D-20261015-1 を反転）

| 図表 | 昨日 | 今日 | 理由 |
|---|---|---|---|
| Fig 1 $W_1$ の定義 | K | K | R1。初見読者の理解（P1） |
| Fig 2 AUC vs $n$（3 cell） | K | K | R2 の核心 |
| **Fig 3 Study 2 の bias / coverage / width** | **X** | **K（復活）** | R3。21 cell の型を一目で示す。文章の数値列挙（約 300 語）を図が代替。表は referee の再計算用に残す |
| **Fig 4 GUSTO 森林図** | **X** | **K（復活、参照線つき）** | R4。$\Delta_{\text{clin}}/L_{\text{UB}}$（age 1 年、SBP 5 mmHg）の点線を入れ、$L^*$ 区間と $L_{\text{UB}}$ の三分類を図が担う |
| Tab required-$n$（13 cell） | K | K | R2 の本体表（blind 印） |
| Tab scenarios | K | K（注を短縮） | ADEMP の DGM。CV・skewness は削除 |
| Tab estimation（21 行） | K | K | R3 の正確値（referee が再計算した表） |
| Tab extension（11 行） | K | K | R3→R4 の橋（operating point E5/E6）。昨日の Harvey 条件④ |
| Tab $W_1$ + rank 区間 | K | K | R4 の推定値（rank 区間は表にしか無い） |
| **Tab $L^*$** | K | **X** | $L^* = \Delta_{\text{clin}}/W_1$ の決定的変換。森林図の参照線が同じ比較を示す。`results/gusto_lstar_intervals.csv` は repository |

図表 8 → 9（図 2 → 4、表 6 → 5）。頁 16 → **15**。

## 2. 文章の判定（R に答えない文を切る）

| 節 | 切った内容 | 答えない理由 |
|---|---|---|
| §1 | SMD は位置のみ、の段落（Tak 承認 08-31、段落ごと純削除） | §2.1 と同じ文 |
| §1 | positioning 段落を圧縮（出典・貢献文は不変） | — |
| §2.2 | 「§4.4 が縮小率を報告」「どちらの bound も支配しない」 | 付録 A.2 と二重 |
| §2.2 | step CATE の文 | §5 が担う（C-21） |
| §2.3 | 「enrolled sample では bound が厳密」 | どの R も使わない |
| §2.4 | proportion scale の文を括弧に、安全係数の NI 比喩を削除 | — |
| §2.4 → §4.1 | GUSTO の $L_{\text{UB}}$ を事例の節へ移動 | Methods は一般、事例の入力は事例に |
| §2.4 + A.2 | Lee の予後勾配 $6.5\times10^{-3}$ の計算 | 論文自身が「保証でない」と書く reference point。R に答えない |
| §3 冒頭 | 圧縮（線形 vs V 字 CATE は残す） | — |
| §3.1.1 | 「oracle」の文を括弧に | — |
| §3.1.3 | $W_1$ vs KS の効率の細部（区間値、bulk-shift の必要 $n$、KS の null SD 比と ΔAUC の数値、AUC 0.95/0.8 の交差文） | 効率は Aim でない（R2 = 盲目でない）。referee #2 が循環を攻めた面。登録 check は 1 句（$W_1$ の比と SE）で開示 |
| §3.2.2 | bias の narration、S2/S5 の $n=200$ 値、MCSE 文、**basic 区間**（post hoc）、RMSE 文 | 図 3 と表が示す。basic 区間はどの主張も使わない |
| §3.2.2 | S1 の 95 percentile 段落 → null coverage の段落に統合 | 同じ主張を 1 箇所に |
| §4.2 | 「推定量が同一分布から出す値」の説明、「by contrast」 | §2.3 と二重 |
| §4.3 | 「Study 1 の必要 $n$ は転用しない」 | 否定する主張がもう無い |
| §4.4 | $L^*$ 表の読みを森林図の参照線の読みに書き換え、R1 の SBP 下限の注 | 図が担う（C-36 narrowed） |
| §5 ¶1 | Study 1 の件数の再掲 | §3.1.2 と図 2 |
| §5 ¶3 | Spearman の計算注を短縮 | — |
| A.1 | 「universal critical value が無い」「S1 の 0 coverage」「R2 の例」 | 本文と二重 |

本文 6,433 → 5,727 語（07:50）→ **5,796 語**（Louis review-fix 後、08:20: Intro 623 / Methods 1,712 / Simulation 1,584 / Application 922 / Discussion 955）。SiM 上限 6,000 の 1.0×。

## 3. 残した「保険文」（Louis、D-20261015-1）

A（PREVENT 1 文）／B（報告しない解析の宣言）／C′（Set 4 の登録 check、$W_1$ の null SD 比と SE、ΔAUC の符号反転）／D′（Region 8 の screening と heaping）／I（$W_d$ の 1 文）／J（KS・$W_2$ bound の 1 文）／survey の向き（§5 ¶4）。いずれも 1 文。

## 4. ゲート（07:50 実測）

build 0 error / 0 undefined / **15 pp**（付録は最終頁に収まる、昨日の 1 頁溢れは解消）／`claim_guards --mutation --strict` 59 本 **0 FAIL**（REF-M3 の「Sets 1 and 2」句と REF-M4 の「at level 0.05」を復元して解消）／`numbers_audit` 111/111 sourced／`cascade_check`（旧 → 新）残滓 0、qualifier 脱落 6（under / where / for the の類）、量化子の強化 3（Louis が精査）／marker 25 箇所 `% Cut 2026-10-15 (D-20261015-2, needs Tak's veto)`。旧原稿 = `review_response/known_bad/per_em_W1_wiley_pre_D-20261015-2.tex`。

図: `R/fig3_w1_axis.R` に参照線（`DELTA_CLIN / L_UB_AGE`、`DELTA_CLIN / L_UB_SBP`）を追加（Katrina 07:39）。`results/gusto_r8_w1_per_pair.csv` は byte-identical。`fig2_simulation_results.pdf` は再生成不要（`R/fig2_bar_chart.R`、`results/w1_raw_summary.csv` = 表と同じ CSV）。

## 5. Louis `/review-fix`（08:06）→ 08:20 最終

Critical 0 / Major 7 / Minor 9。採用: M1（coverage の軸は bias / sampling SD）、M2（extension は 0.2 SD の cell）、M3（Set 4 の 4 値と MCSE を復元）、M4（basic 区間の 1 文を復元 — 昨日の保険を落としていた）、M5（CLAIMS の Claim 列を narrow、C-45 retract）、M6（参照線は pooling の閾値でない — §4.4 本文と caption）、M7（「curves cross near the target」を削除）、m1・m2・m3・m5・m7。guard 6 本 `LF2-*` を seed（known_bad = `known_bad/per_em_W1_wiley_20261015_0750_essence.tex`）。最終ゲート: build 0 error / **15 pp**、`claim_guards` **65 本 0 FAIL**、`numbers_audit` 113/113、`cascade_check` 残滓 0。詳細は `DECISIONS.md` D-20261015-2 の末尾。
