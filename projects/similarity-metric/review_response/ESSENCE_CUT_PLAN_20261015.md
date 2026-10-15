# ESSENCE CUT PLAN — per_em_W1_wiley.tex（2026-10-15、副編集長/コピーエディタ視点）

対象: `paper/per_em_W1_wiley.tex`（838 行、%コメント除く）。行番号は現ファイルのもの。語数は目視見積り（±15%）。原稿は未編集。

## 1. 本質（5 文）

1. ICH E17 は地域プールを効果修飾因子（EM）分布の類似性で語るが、その測度を与えない。本論文は EM ごとの Wasserstein-1 距離 $W_1$（元の単位）で地域間の分布差を定量する。
2. 共通で Lipschitz（傾き $L_{clinical}$）な CATE の下で、地域 ATE 差は $L_{clinical}W_1$ 以下（Kantorovich–Rubinstein）。$L_{clinical}$ 不明なら $L^*=\Delta_{clin}/W_1$ を逆算し、スポンサーの上限と比べる。
3. Study 1: SMD は平均一致セルで盲目（どのサンプルサイズでも AUC≈0.5）、$W_1$ と KS は回復する。
4. Study 2: 推定量は上方バイアスがあり、percentile bootstrap の被覆は 0.95 を下回るセルがある（null 付近は構造的に 0）。null floor で「差と区別できない距離」に印を付ける。
5. GUSTO-I 例: 年齢と SBP でパートナー順位が食い違う。判定規則は与えず、定量化のみ。

**この 5 文に直接寄与しない塊**（下の CUT 候補の母集団）: KS bound の比較の細部、Study 1 の「報告しない解析」の列挙、Study 2 の追加検査（basic interval、Set 4 control の機構、拡張 Study の全セル表）、GUSTO データ screening の感度分析、real-data survey、多変量 $W_d$ の展開、すでに Sec.2 で述べた事柄の Discussion での再掲。

## 2. 段落単位の判定（本文）

凡例: K=KEEP / C=COMPRESS（目標語）/ X=CUT。現語数は概算。

### Abstract（42–43 行、約 245 語）
- C→215。「selection simulation (matches supplied)」「MCSE の 10 セル中 k」等の防御的限定が密。$W_1$ 到達 AUC の文と被覆の文を 1 文ずつ短く。（Abstract は本文語数にほぼ含まれないが 250 語上限に余裕を。）

### 1 Introduction（62–110 行、約 1,150 語 → 目標 650）
| 行 | 段落冒頭 | 判定 | 理由 |
|---|---|---|---|
| 65 | Multi-regional clinical trials (MRCTs), conducted across… | C 70→45 | 一般的背景。E17 採択の一文のみ残す |
| 68 | Regulatory authorities in Japan and China… | C 85→60 | 65 行と統合し 1 段落に |
| 71 | An effect modifier is a baseline patient characteristic… | C 160→90 | 読者は専門家（Tak 方針）。「若い患者が多い地域」の例示を 1 文に。categorical 除外は Discussion の限界にあるので重複 |
| 80 | Despite the regulatory importance… | C 330→190 | 最長。Song/Komiyama の紹介が長い。Komiyama は「例として cluster 分析が紹介されているが距離の評価はない」程度で足りる（Tak 方針: 比較せず・拡大解釈せず）。Two gaps は残す |
| 83 | The ingredients are not new in themselves… | C 190→120 | 先行文献の位置づけは必要。ただし propensity-score/generalizability/trimmed Mallows を 1 文に畳める。contribution 文は残す |
| 87 | In the PREVENT trial of secukinumab… | **X** 150→0（保険 1 文: 下記 §5-A） | 論文自身が「BINARY で今回の話と異なる」「EM のせいではない」と書く。動機づけとして逆効果。Intro の 68 行に post hoc プールの例が要るなら 1 節で |
| 93 | General-purpose comparison tools such as the SMD… | K 55 | 動機の核（ただし Methods 2.1 と重複 → 2.1 側を削る方が良い。§4-#7 参照） |
| 101 | This paper addresses these gaps… | K 60 |  |
| 110 | The remainder of this paper is organized… | **X** 55 | roadmap。Wiley 論文で不要 |

### 2 Methods（113–281 行、約 3,000 語 → 目標 1,700）
| 行 | 段落冒頭 | 判定 | 理由 |
|---|---|---|---|
| 117–122 | Let the CATE be… (eq. regional_ate) + collapsibility | K 150→120 | collapsibility は 1 文に短縮 |
| 129–142 | The most widely used measure… SMD / EDF / KL | C 190→100 | SMD 式（eq 2）と KL 式（eq 3）は本文で再利用されない。KL の式は削除、SMD は式なしで「平均差/プール SD」。例 N(50,5²) vs N(50,15²) は 1 行で残す |
| 147 | Each of these approaches has limitations… | C 230→110 | 135 行「SMD は位置のみ」と 93 行 Intro と三重。要件 (i)-(iii) の列挙だけ残す。KS の TV 定数の説明は Appendix A.3 に既出 |
| 154 | Among distributional distances… we adopt $W_1$ for three reasons | C 190→130 | 三理由は残す。「保守的上界」の言い換えを 1 つ削る |
| 158–161 | eq (wasserstein) + three forms + Figure 1 | K 130 | Fig 1 は残す（§3）。三表現の説明は 1 文ずつ |
| 170 | $W_1$ carries the units… | C 190→90 | 三つの形すべてで単位が出る説明は 1 文。5 mmHg の例は残す |
| 172–177 | $W_1$ is a proper metric… affine-equivariant… KR dual | C 190→130 | 「proper metric の 4 性質」は列挙不要（Appendix A.1 で非負性と identity を証明しているのも **不要**、§3 参照） |
| 180–190 | Proposition + Proof | K 130 | 核 |
| 201 | Equation (heterogeneity_bound) is not the only bound… (KS, W2, sharp τ*, monotone) | C 380→200 | 最重要の削減候補。sharpness（τ* 構成）と monotone 版 eq.(mono_bound) は残すが、KS bound・$W_2$ の話は Appendix A.3 にあるので本文から落とす。「sharp の対象は class の性質」の 1 文は残す |
| 209 | which equals $L W_1$ when the CDFs do not cross… | C 250→100 | 「Sharpness は KS にもある」「neither dominates」は A.3 の重複。application での shrink factor の予告も 647 行と重複 |
| 214 | The right-hand side of equation… involves $W_1$ in its original units… | C 120→60 | 「正規化は不要」と「step CATE で保守的」は Discussion (733 行) と二重 |
| 220–230 | Given samples… estimator; asymptotic; Wald vs bootstrap; consistency conditions | C 520→300 | Brownian-bridge 極限・Hadamard 微分・rate は Appendix A.2 と重複。Wald を採らない理由は 1 文。bootstrap の手続き（B=2000, 型 7）は残す。O(n log n) の最終文は X（80 語中 25） |
| 235 | Because $W_1$ is a distance, $\widehat W_1$ is non-negative… null floor | C 430→260 | 核だが長い。「enrolled sample では bound が厳密に成り立つ」「多重性」は 1 文ずつ。「Declaring a distance unresolved … one-sided test of level 0.05」は残す |
| 248 | We refer to the Lipschitz constant… clinical slope | C 290→170 | 「proportion scale で quote」「meta-regression は下界」「safety factor」を各 1 文に。IPD 略語の定義は Abbrev. 欄にある |
| 250–255 | $\Delta_{\max}$ definition | K 90 | 「normalized form は cancel」文は **X**（40 語、214 行と重複） |
| 258–264 | $L^*$ definition + interval + $L_{UB}$ comparison | K 230→190 |  |
| 275 | Specifying $L_{clinical}$ … is a clinical judgment | C 380→150 | 重い。$R_a(x)$ 分解・prognostic vs predictive（Ballman, Kent）は 1 文。GUSTO の例示 bound の設定根拠・Lee et al. 6.5e-3・「全体の治療効果に比べ大きい」は application 側（1 箇所）に寄せるか、いっそ「illustrative、根拠は reference points」で止める。Appendix A.3 への参照も不要になる |
| 281 | The pooling assessment proceeds by… estimation-centered | C 200→110 | 手順の再列挙。「estimation-centered で testing でない」は残す。「the one test, the null floor…」は 235 行にある |

### 3 Simulation（284–534 行、約 3,000 語 → 目標 1,900）
**3 冒頭（291, 298）**
- 291 "We conducted two complementary simulation studies…"（260 語）: C→110。線形 CATE と V 字 CATE の対比は **Study 1 の存在理由であり重要** → 1 文に圧縮して残す。「Study 1 は X を評価しない」の自己限定の列挙は 2 項目に。
- 298 "Study 1's required sample sizes are discrimination statements…"（70 語）: **X**。表と §3.1.3 が同じ範囲を述べる。

**3.1 Study 1**
- 318 Design（390 語）: C→230。Set 1–4 の構成は必要。Set 4 の「KS は ε、$W_1$ は εd」機構説明は 1 文に（結果段落 356 行でも「by construction」を再度説明している）。
- 324 "Three measures enter the comparison… Under the registered protocol the simulation also evaluated…"（200 語）: C→70（保険: §5-B）。「報告しない解析の列挙」は読者に不要（自己申告の列挙の典型）。SMD の log 尺度結果は 1 文だけ、本文でなく表注か Discussion でなく **削除**してもよい。
- 329 "The measures are scored against the construction label…"（200 語）: C→140。事後に決めたこと（grid 拡張、target、定義）の開示は 1 文で。
- 336/340（blind と recovering の 2 段落、約 270 語）: C→170。KS の最弱セル AUC の値と SMD の blind セル列挙は表 Table 8 にある。
- Fig 4（fig_required_n_auc）: 残す（§3）。
- 356 Required-n 段落（約 520 語）: **C→200**。最大の数値並べすぎ。「W1 が KS より少ないのは 11 セル中何、3 つは構成による」を 1 文＋表。bulk-shift control の逆転は 1 文。Set 4 anchor 検査（null SD 比、paired ΔAUC の符号反転、MCSE 各々）は **丸ごと X**（保険: §5-C、1 文）。
- 358 "In the shape-symmetric mixture the two AUC curves cross…"（150 語）: C→60。
- 375 fixed-n error rate（70 語）: **X**。表と AUC で既出、かつ「構成上 W1 に有利」と自ら書く。

**3.2 Study 2**
- 401 + Table 2 + 注（430 語）: C→250。表注の S6 パラメータ・数値積分の詳細・「Monte Carlo 真値で share を計算」は表注 1 文に。
- 427 "For each scenario, we generated samples…"（200 語）: C→90。PSOCK / L'Ecuyer / seed 式 / 非 bit 再現の話は **X**（Data availability と sessionInfo に）。
- 430–437（性能指標 4 項目の enumerate、80 語）: **X**。表注が bias, RMSE, coverage, width を定義済み（重複）。
- 443 Bias (null)（150 語）: C→90。
- 458 Bias non-null（190 語）: C→90。n^{-1/2} の収束速度の議論は本質でない（Aim は距離を提示すること）。「n=200 のバイアスは最大 X」で足りる。
- 469 + 472 Coverage（約 330 語）: C→200。被覆の説明（S5/S7 では上方バイアス、S6/S4 は両側）は 1 段落に統合。S4/S5/S2 の n=50 の数値並べは表で足りる。
- 480 Coverage for S1 = zero + miss side（260 語）: C→150。S1 構造的 0 は表注に既出（Table 3 注、図 caption にも）→ 本文で 1 回だけ。
- 483 MCSE + one-sided upper-limit + basic interval（330 語）: **C→110**。basic interval は「post hoc、事前登録なし」と自ら書いており、本文の主張を支えない → 全体を **X**、upper-limit 被覆は 1 文だけ残す（application で上限を読むので必要）。Table 4（intervals）は §3 参照。
- 497 + Table 5 拡張（約 400 語＋ 表）: C→150、表は本文から Appendix へ移すか圧縮。operating point（E5/E6）の被覆 2 値だけが GUSTO 節で引かれる。
- 514 RMSE and CI width（200 語）: C→90。「RMSE は $O(n^{-1/2})$」は教科書的。$\Delta_{max}$ 幅/margin の例は残す（n=100 でも幅が広い、という正直な 1 文）。
- 519 S1 95th percentile（60 語）: K 50（null floor の参照値として必要）。

### 4 Application（537–659 行、約 1,300 語 → 目標 750）
- 542 導入（150 語）: C→100。
- 548 EM の選択（約 190 語）: C→100。FTT の引用説明を 1 文に。
- 556 anchor 選択 + データ screening（約 330 語）: **C→130**。0 mmHg/100 歳超の感度分析（Winsor、順位変更数）は事後・防御的。1–2 文＋保険（§5-D）。heaping の話は Appendix A.2 にも出る。
- 576 Null floor 計算（200 語）: C→130。permutation test との一致は 1 文で。
- 586 / 595（2 段落、約 350 語）: **C→140**。595 は「Study 2 の被覆は距離 / SD 比で決まる」「拡張セルで確認」を再度述べる（Study 2 と Discussion 733 と 3 重）。
- 604 Study 1 の required n は転用しない…（130 語）: C→60。
- 629 / 633 ランクの不確かさ、R2 と R9 の反転（約 270 語）: C→150。629 は表注に既出。633 の対比は **残す**（要点: EM 間でランクが一致しない）が Discussion 679 と重複。
- 647 Clinical interpretation（約 280 語）: C→170。三分類の読み方は 1 文ずつ。monotone ratio の範囲は残す。
- Table 7 等: §3 参照。

### 5 Discussion（662–743 行、約 2,100 語 → 目標 1,000）
- 672 第 1 段落「This paper answers the requirements…」（約 330 語）: **C→110**。要旨の再掲（Abstract と Sec.3 の数値を 3 回目）。数値は $\numval{}$ を全部削除してよい。
- 679 two implications（約 160 語）: C→90。R2/R9 の話は 633 行と重複 → どちらか 1 箇所。
- 688–690 Komiyama と Spearman（約 230 語）: C→90。「clustering は報告しない」は Study 1 に同旨。Spearman の主旨（距離は EM 間で一致しない、集約するとマスクされる）だけ。
- 700 Of the limitations set out in Section 2.1…（**約 560 語**）: **C→120（最大の単一段落）**。「W1 は SMD とほぼ同じ順位（Spearman）」と「3 試験 survey」と「KS 比較の効率」と「採用理由 3 つ目」が詰め込まれている。survey（GUSTO-I, IST-1, IST-3、\numval 10 個超）は本文の Aim に答えない（S22）。残すのは「GUSTO-I の地域差はほぼ位置差なので W1 と SMD は似た順位を与え、W1 の付加価値は臨床尺度への換算」の 2 文。Data availability の IST DOI 文も同時に落とせる。
- 715 RWE で planning 段階に使える（約 120 語）: C→60。
- 719 / 721 limitations（約 380 語）: C→200。719 の binary/ordinal の括弧、721 の S2/S5 被覆の数値再掲（\numval 4 個）は Sec.3 の再掲。
- 733 Lipschitz premise limitations（**約 430 語**）: **C→170**。「局所性」「additive 分解」「重み付き $W_d$ joint bound」は面白いが本論文の Aim の外（IDEAS_BACKLOG 行き）。残すのは (1) 定数は臨床判断、(2) step CATE では保守的（設計上）、(3) per-EM なので EM 間交互作用は捉えない（1 文）。
- 739 Inference tailored to the boundary（40 語）: K 40（future work の唯一の具体案）。
- 743 principal contribution（80 語）: K 60。

### 付録（779–836 行）
- A.1 非負性・identity（783–785, 約 140 語）: **X**。教科書事項（Villani 引用済み）。
- A.1 の Jensen 上方バイアス（788, 約 45 語）: K。ただし A.2 に移動して A.1 を廃止。
- A.2 Asymptotic（792–800, 約 350 語）: C→200。本文 230 行と同内容 → 本文側を薄くして付録に寄せるか、逆。どちらか一方に。
- A.3 KS 比較（805–808, 約 380 語）: C→150。「W1 が KS に常に勝つわけではない」の 1 文＋「bound は有界な範囲で τ* が非現実的効果を要する」（Lee et al. 計算）。ただし後者は上記 Methods 275 行の bound 設定論から外れれば不要。
- B R コード（810–836, 約 150 語＋リスト）: **X**。Data availability に repository がある。Wiley に付録コード 25 行は不要。ただし `lstlisting` が頁を占める分約 0.5 頁。

## 3. 表と図 13 個の判定

| # | 内容 | 判定 | 理由 |
|---|---|---|---|
| Fig 1 (fig1_w1_definition) | $W_1$ = CDF 間面積 | **K** | 概念図。ただし 0.8 幅→0.6 幅に縮小可（頁節約） |
| Fig 2 (fig2_simulation_results) | Study 2 の bias / coverage / width の 3 パネル | **K** or X | Table 3 と同内容。図か表のどちらか 1 つで足りる → 図を残し Table 3 を Appendix 送り、が読者に優しい。どちらかを選べ |
| Fig 3 (fig_required_n_auc) | AUC vs n の 3 セル | **K** | Study 1 の核心の可視化 |
| Fig 4 (fig3_gusto_r8_forest) | $\widehat W_1$ の森林図 | **C** | Table 8 (gusto_nabcd) と数値が同じ。**図を残して表を表 9 に統合**、または森林図を削る。ランク区間を図に載せられるなら表 8 を削除 |
| Tab 1 scenarios (S1–S7) | シナリオ定義 | K（注を縮小） | 注 5 行 → 2 行 |
| Tab 2 estimation | bias/cov/RMSE/width 21 行 | **K（本体）** | ただし RMSE 列を落とす（Aim 外） |
| Tab 3 study2_intervals | percentile / upper / basic 被覆 | **X** | basic interval は post hoc。上側 97.5% 被覆は Tab 2 に 1 列追加して統合 |
| Tab 4 study2_ext | 拡張セル 10 行 | **C→Appendix** or 圧縮 | GUSTO 節が引くのは E5/E6 のみ。それ以外 8 セルは表でなく 1 文（被覆範囲）。表は E5/E6 の 2 行に |
| Tab 5 required_n_mc | 13 セル × 3 測度 | **K** | Study 1 の本体表（Fig 3 と組） |
| Tab 6 gusto_r8 | Region 8 ベースライン | **X** | 本文 N のみ使用。Table は読まれない。SBP/年齢の平均 SD を 1 文に |
| Tab 7 operability | null floor の範囲 | **C** | 3 行の表。本文 586 行（6/15, 14/15）で足りる → X でもよい（保険: 1 文） |
| Tab 8 gusto_nabcd | 15 パートナー × 2 EM、ランク区間 | **K（本体）** | 森林図と統合（上記） |
| Tab 9 gusto_lstar_joint | $L^*$ 区間 | **K** | $L^*$ の適用例として唯一の表 |

**結果**: 13 → 9（Tab 3, 6 削除、Tab 4 圧縮、Tab 7 を本文へ、Fig 2 と Tab 2 の役割整理で最大 -1）。頁数で -2〜-2.5 頁見込み。

付録: A.1 非負性（X）、A.2 を本文と二重管理しない、A.3 圧縮、B コード（X）。付録全体で約 1 頁減。

## 4. 目標語数と最小削除セット

### 節別目標（本文語数）
| 節 | 現状 | 目標 |
|---|---|---|
| Abstract | 245 | 215 |
| 1 Introduction | 1,150 | 650 |
| 2 Methods | 3,000 | 1,700 |
| 3 Simulation（Study 1 ＋ Study 2） | 3,000 | 1,900 |
| 4 Application | 1,300 | 750 |
| 5 Discussion | 2,100 | 1,000 |
| 付録 | 約 1,000 | 500 |
| **合計（本文 1–5）** | **約 9,700** | **約 6,000（許容 6,300）** |

頁: 21 → 約 15（語数 -35% と表 4 削減）。

### 削除セット（効果の大きい順）
| # | 節・行 | 段落冒頭 | 操作 | 削減語数 |
|---|---|---|---|---|
| 1 | Disc. 700 | Of the limitations set out in Section 2.1… | 560→120。survey（IST-1/3）・KS 効率・Spearman 数値を落とす | −440 |
| 2 | Disc. 733 | The calibration rests on the Lipschitz premise… | 430→170。局所性・additive・$W_d$ 展開を落とす（`/idea`） | −260 |
| 3 | Study1 356 | Table~\ref{tab:study2_required_n_mc} reports, for all… | 520→200。Set 4 anchor 検査を全削除 | −320 |
| 4 | Meth. 201 + 209 | Equation (heterogeneity_bound) is not the only bound of its form / which equals… | 630→300。KS/W2 比較を付録へ寄せ尽くす | −330 |
| 5 | Study2 483 | Monte Carlo standard errors for the reported coverage… | 330→110。basic interval と事後比較を全削除 | −220 |
| 6 | Intro 80 | Despite the regulatory importance… | 330→190 | −140 |
| 7 | Meth. 275 | Specifying $L_{clinical}$… | 380→150 | −230 |
| 8 | Disc. 672 | This paper answers the requirements… | 330→110 | −220 |
| 9 | Study1 324 | Three measures enter the comparison… | 200→70 | −130 |
| 10 | App. 556 | The sponsor selects Region 8… (screening) | 330→130 | −200 |
| 11 | Meth. 230 + 235 | where $\hat F_r$ denotes… / Because $W_1$ is a distance… | 950→560 | −390 |
| 12 | Study2 427 + 430–437 | For each scenario, we generated… + 性能指標 enumerate | 280→90 | −190 |
| 13 | App. 586+595 | The two candidate effect modifiers… / small age distances… | 350→140 | −210 |
| 14 | Intro 87 | In the PREVENT trial… | CUT | −150 |
| 15 | Intro 110 | The remainder of this paper… | CUT | −55 |
| 16 | Study1 375 | The required-n comparison is complemented… | CUT | −70 |
| 17 | Disc. 688–690 | These implications also bear on… | 230→90 | −140 |
| 18 | Meth. 147 | Each of these approaches has limitations… | 230→110 | −120 |
| 19 | Study2 458/469/472/480 | Bias non-null / Coverage 段落群 | 約 780→440 | −340 |
| 20 | Study2 497 + Table | registered extension | 400→150 | −250 |
| 21 | App. 647 | Table~\ref{tab:gusto_lstar_joint} reports… | 280→170 | −110 |
| 22 | Study1 291 | We conducted two complementary simulation studies… | 260→110 | −150 |
| 23 | Study1 298 | Study 1's required sample sizes… | CUT | −70 |
| 24 | Meth. 129–142 | The most widely used measure… (KL 式 eq.3) | 190→100 | −90 |
| 25 | 他（Intro 65–71, Meth. 170/172/214/248, Disc. 715/719/721, 付録）の小口 | | | 約 −1,000 |

合計見積り: 約 −5,900 を超え、目標 −3,500〜−3,700 に対して余裕がある（優先順は上位 15 件で約 −3,300、1–19 で約 −4,000）。**最小セットとしては #1–#13 ＋ #14–#16 で約 −3,500 語。** 表の削減（Tab 3, 6, 7、Tab 4 圧縮、コード付録、A.1）で語数外に約 −3 頁。

## 5. 保険案（保険は最小限、各 1 文）

- **A. PREVENT / Matsushima の段落を CUT する代わりに**: Intro 68 行の末尾に「Pooled regions have been formed post hoc from effect modifier distributions in practice (Matsushima et al.).」を 1 文。査読者が「動機となる実例は？」と聞く保険。
- **B. 報告しない解析の列挙を CUT する代わりに**: 1 文「Other measures and tasks run under the registered protocol are not reported; they bear on grouping or eligibility rules, which this paper does not prescribe.」これで Rule 6 の開示と「選択的報告」への反論が立つ。
- **C. Set 4 anchor 検査を CUT する代わりに**: 「In the bulk-shift control, where the displaced subgroups are absent from the shift, the KS statistic reaches the target first; this cell was registered as the check on the construction.」で十分（SD 比・ΔAUC の符号反転・MCSE は repository）。
- **D. GUSTO データ screening を CUT する代わりに**: 「Records with SBP = 0 or age > 100 were retained; excluding them changed no null-floor classification.」（定量は repository）。
- **E. basic interval を CUT する代わりに**: 不要。post hoc で主張に使っていない → 保険なし。査読者が聞いたら応答書で答える。
- **F. survey（IST-1/3）を CUT する代わりに**: 不要。本文は「GUSTO-I のみ」。査読者が「他データでも W1 と SMD は似るか」と聞けば応答書で出せる（IDEAS_BACKLOG 行き）。
- **G. KL の式を CUT する代わりに**: 不要。KL 発散は誰でも知っている。「asymmetric, infinite on non-overlap」の 1 文は残す。
- **H. Wald 区間を採らない理由**: Meth. 230 行から 1 文だけ残す（「Wald 区間は交点位置に依存する分散推定が要る」）。査読者に必ず突かれる。
- **I. 多変量・EM 間交互作用を CUT する代わりに**: Discussion に「Per-modifier distances do not capture interactions between modifiers; the joint analogue is a multivariate problem outside this paper.」の 1 文。$W_d$ の式は削除。

## 6. 「著者が手放したがらなさそうだが、読者のためには手放すべき」トップ 10

1. **Real-data survey（IST-1, IST-3, \numval 約 10 個）と Data availability の IST DOI**。Aim（W1 を提示）に答えない（S22）。本文で最も「手間をかけた感」が出ている箇所だが、読者には GUSTO-I と似た順位という副次的観察に過ぎない。
2. **Set 4 anchor 対 Gaussian anchor の機構検査**（null SD 比 ×MCSE、ΔAUC の符号反転）。登録済み・手間がかかったが、結論は「control は W1 に不利」の 1 文。
3. **basic (reflected) interval と上側被覆の事後比較（Table 4 + 483 行）**。自ら「not pre-specified」と書く。
4. **PREVENT / Matsushima 段落**。自ら「binary で別件」「EM が原因ではない」と書き、動機づけとして機能していない。
5. **Study 1 の「報告しない解析」の列挙**（log-SMD、harm measure、silhouette clustering、threshold 研究、eligibility rule）。自己申告の列挙であり、読者に必要なのは「何を評価したか」だけ。
6. **Discussion 733 行の $W_d$ 結合 bound、局所性、additive 分解**。数学的に美しいが別論文のネタ（`/idea` に登録して手放す）。
7. **KS bound 比較・$W_2$ 比較・TV(τ) の話（Meth. 201/209/147、Appendix A.3）**。「W1 だけが特別ではない」という referee 対策だが、本文の読者は $W_1$ の bound の使い方を知りたい。A.3 に 150 語で十分。
8. **GUSTO データ screening の感度分析（winsor、順位変更数、heaping）と Table 6 (Region 8 ベースライン)**。事後の防御。1 文＋ repository。
9. **Study 2 拡張セルの全 10 行表（Table 5）と PSOCK/RNG/seed の実装記述**。再現性は repository・sessionInfo で担保済み。
10. **Appendix B の R コード**と **A.1 の非負性・identity の証明**。どちらも教科書事項／repository にあり、載せる頁数に見合わない。

---
*補足*: 数値は \numval 経由なので、削除したキーは registry 側に残してよい（numbers_registry check の unused は警告のみ想定）。削除後は CLAIMS/CLAIM_GUARDS の guard が落ちる箇所があるはずなので、/claims check と guard 外しの `/decide` を別途要す（本プランの範囲外）。語数は概算で、実測は `texcount` を推奨。
