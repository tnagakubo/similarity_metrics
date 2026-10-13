# External review — received from Tak 2026-10-12 16:07（原文、日本語。出所は Tak 経由の外部 reviewer；原稿は 2026-10-12 11:23 版 = D-20261012-2 適用後）

> Triage: Harvey、`DECISIONS.md` D-20261012-3。Louis の攻撃: `review_response/EXTERNAL_REVIEW_ATTACK_20261012.md`。

## 総評

研究の動機（ICH E17が求める効果修飾因子分布の類似性に、具体的な尺度がない）は明確です。$W_1$を用いて臨床的にキャリブレーションするという方向も筋が良いと思います。Table 9の$L^*$と区間は$\Delta_{\text{clin}}/\widehat W_1$から再計算でき、整合していました。

一方、Statistics in Medicine級の査読を想定すると、次の4点で major revision を求められる可能性が高いです。

- 理論的貢献の新規性
- 推測手法の妥当性
- シミュレーションの評価基準が研究目的とずれていること
- 応用例でアウトカムを使っていないこと

## Major issues

### M1. Proposition 1 の新規性と先行研究の欠落

Proposition 1は、Kantorovich–Rubinstein双対をそのまま適用した1行の系です。$|\int\tau\,d(F_1-F_2)|\le L\,W_1(F_1,F_2)$ — この形の不等式は、covariate shift下でのリスク差のbound（domain adaptationのOT理論。Redko et al. 2017、Shen et al. 2018など）として既に標準的です。査読者は「主結果は既知」と指摘するでしょう。

さらに、次の近接分野が引用されていません。
- 一般化可能性・移植可能性（generalizability / transportability）：Stuart et al. (2011, JRSS-A)、Dahabreh et al. (2020, Stat Med)。特にTipton (2014) のgeneralizability indexは、「試験集団と目標集団の分布類似度を一つの指標で測る」という本稿とほぼ同じ問題設定です。
- 分布の類似性の検定：Munk & Czado (1998, JRSS-B)、Álvarez-Esteban et al. (2008, JASA) は、trimmed Wasserstein（Mallows）距離で「関連する差がないこと」を同等性検定として扱っています。

対応案：新規性の主張は「boundそのもの」ではなく、(1) MRCTのプーリングという文脈への定式化 (2) 臨床傾き$L$による逆算（$L^*$）という読み方 (3) 推測手法の性質の評価 — に置き直すのが安全です。

### M2. 推定対象（estimand）の前提：非可縮な効果指標

$\bar\tau_r=\int\tau\,dF_r$が成り立つのは、リスク差や平均差のような可縮（collapsible）な指標に限られます。MRCTの一貫性評価では、HRやORで評価することが多いです。周辺HR・周辺ORは条件付き効果の$F_r$平均ではないため、Proposition 1は直接適用できません。対応案：適用範囲をリスク差、RMST差、平均差に限定すると明記する。または、周辺効果をg-formula（標準化）で定義したうえで、その場合の扱いを議論する。

### M3. Study 1 の評価基準が研究目的とずれている

Study 1が評価しているのは、「同一分布の候補をどれだけ識別できるか」という検定的な検出力です。しかし本稿の目的は、「地域平均効果の差に関連する距離で地域を順序づけること」です。両者は一致しません。CATEが線形の場合、$\bar\tau_1-\bar\tau_2=L(\mu_1-\mu_2)$ なので、効果差に関係するのは平均差だけです。スケールだけが異なる地域は効果差0なのに、$W_1>0$で「遠い」と判定されます。SMDが"blind"であることは、ここでは欠点ではなく正しい挙動です。

対応案（Study 3として追加を強く推奨）：CATEとして線形・二次・閾値型・飽和型を生成し、真の$|\bar\tau_1-\bar\tau_2|$を計算する。各尺度について、真の効果差による順位との一致度（Spearman、上位$k$の一致率）と boundの保守性 $|\bar\tau_1-\bar\tau_2|/(L\,W_1)$ を評価する。あわせて、比較対象に Cramér–von Mises、Anderson–Darling、energy distance（1次元では$2\int(F_1-F_2)^2dx$）を加えるべきです。

### M4. 推測手法：境界近傍での percentile bootstrap

(a) 正のバイアスは厳密に示せます。$E\hat F_r(x)=F_r(x)$なので、JensenとFubiniから $E\,\widehat W_1=\int E|\hat F_1-\hat F_2|\,dx\ \ge\ \int|F_1-F_2|\,dx=W_1\quad(\forall n)$。命題として明記すべきです。
(b) 区間がバイアスを補正していません。percentile区間はバイアスを補正しないため、境界近傍では区間全体が上方にずれます。Table 8: R5（age）0.39 [0.35, 0.92]、R7（age）0.40 [0.30, 0.95] — 点推定が下端の近く、非対称性が極端。
(c) 推奨する追加評価：basic / BCa bootstrap、bias-corrected推定量 $2\widehat W_1-\bar W_1^*$ との比較；m-out-of-n bootstrap（Bickel, Götze, van Zwet 1997）、numerical delta method（Hong & Li 2018）。
(d) 主たる評価量を片側上限に移す。判断に効くのは上側信頼限界のcoverageです（$L^*$の下限 $\Delta_{\text{clin}}/W_{1,U}$ として使われるため）。片側97.5%上限のcoverageを主要な評価量として表にすべきです。

### M5. 判断ルールとしての動作特性がない

「判断は臨床判断に委ねる」という立場は理解できます。しかし査読者は「事前に規定できる手順と、その動作特性」を求めます。自然な定式化は同等性検定 $H_0:\ L_{UB}\,W_1\ge\Delta_{\text{clin}}$ vs $H_1:\ L_{UB}\,W_1<\Delta_{\text{clin}}$。「$\widehat W_{1,U}<\Delta_{\text{clin}}/L_{UB}$ のとき棄却」。第1種の過誤と検出力をシミュレーションで示すと主張が強くなります。あわせて null floor: 「差が検出されないこと」は類似性の証拠ではない；null floorは anchorの経験分布からのbootstrapではなく、プールした標本でのpermutation検定にすれば交換可能性の下で正確；30回の検定の多重性にも一言。

### M6. 多変量性：周辺分布ごとのboundの限界

重み付き$\ell_1$距離 $d(x,y)=\sum_k L_k|x_k-y_k|$ の下で同時分布の $W_d$ を考えると、KR双対から $|\bar\tau_1-\bar\tau_2|\le W_d(P_1,P_2)$ が、CATEが$d$に関してLipschitzであれば因子間の交互作用があっても成り立ちます。任意のcouplingに対して $W_d(P_1,P_2)\ge\sum_k L_k W_1^{(k)}$ なので、周辺分布の和は同時分布の距離の下界になり、交互作用がある場合に周辺分布だけでは過小評価になる。GUSTO-Iで同時分布の$W_d$（2次元なら線形計画）を併記すると説得力が増します。

### M7. 応用例でアウトカムを使っていない

(a) $L_{UB}$の妥当性：$L_{UB,\text{age}}=0.01/\text{yr}$ は10年あたり10%ptで、全体の治療効果（約1%pt）や予後の勾配（約0.6%pt/yr）と比べてかなり大きい。GUSTO-I内でスプラインで年齢との交互作用を推定し、$\sup|\hat\tau'|$とそのCIを示す；$L_{UB}$を格子状に変えたときの感度分析。
(b) 直接の標準化推定との比較：$\int\hat\tau\,d(\hat F_1-\hat F_2)$ と worst-case bound の比較で保守性を示す。
(c) データの品質：SBP=0の6例と100歳超の3例を「記録どおり」使うのは、$W_1$の影響関数が有界でない以上、防御しにくい。除外・winsorize の感度分析；SBPの末尾数字の選好（digit preference）が地域で異なればそれだけで$W_1$が生じる。

### M8. Study 2 の範囲が応用と合っていない

Study 2（$n\le200$、等 n、正規基準）と応用（1,231〜4,352、不均衡、整数格子）。追加すべき設定：$n$の不均衡、裾の重い分布（$t_3$）、格子化・丸めたデータ、大きな$n$。coverageが10セル中5セルで0.95を下回る原因は説明されているが改善策が無い。

## Minor issues

1. 実際の地域部分集団（例：$n=50$）では、登録患者の経験分布のばらつき自体が標本レベルの地域効果差に$L\,W_1(\hat F_1,\hat F_2)$程度寄与する。$\sigma=10$、$n=50$でnull floorが約4.2 — 母集団差より標本変動が支配的になり得る。一段落あると良い。
2. $\tau^*$の許容性：attainment の議論は有界な台を前提。非有界な台では$|\tau|\le1$の下で上限が達成されない。条件を明示。
3. post hocな設計選択：事前登録との差分を表で；未報告の尺度はSupporting Informationに。
4. 抄録：数値が過密、「11 of 13 (three by construction)」が本文全体で繰り返される。主張を3つ程度に。
5. Section 2.2の密度：KS boundとの比較を Remark として分離するか Appendix へ。
6. Spearman相関の解釈：$-0.30$（95% CI $[-0.51, 0.02]$）は0を含む。「一致しない」は強すぎる。

## 体裁・誤植

- Figure 4のキャプション：「daggerDistance … (Table eftab:operability)」でLaTeXが壊れている。
- IST-1の引用：本文の「IST-125」は IST-1 と参考文献 25 が結合。参考文献25の表記は IST-1 に統一。
- 著者名：参考文献11「Barrio dE」は del Barrio E、19「Klaveren vD」は van Klaveren D（BibTeX で `{del Barrio}`、`{van Klaveren}`）。
- 書誌情報：「How to cite」のページ数（1–18）と実際（1–21）、年が不一致。
- Appendix B の R コード：`F1(all_vals[-length(all_vals)])` を2回評価。`head(all_vals, -1)` を変数に。再現用リポジトリで tidyverse／Rcpp 版との対応を明記。

## 優先順位

1. M1 2. M3 3. M7 4. M4・M5 5. M2。M6 は余力があれば。
