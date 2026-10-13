# LENGTH_CUT_20261014 — 本文の削減（D-20261014-1、Tak「本文を削減して」）

> Katrina の作業記録（hand-back を Donna が転記; 01:03）。規則: (1) CLAIMS の行の唯一の担い手は切らない、(2) 10-12/13 の訂正文は切らない（数値・限定句・引用が全部残る圧縮のみ）、(3) Tak 承認段落は純削除のみ、新文言は `% Cut 2026-10-14 (D-20261014-1, needs Tak's veto)`、(4) guard の key・1 回しか出ない \cite・abstract・省略宣言・protocol 文・Data availability は維持。切る前の原稿: `paper/backup/length_cut_20261014/per_em_W1_wiley_pre_cut_20261014.tex`（+ `review_response/known_bad/per_em_W1_wiley_20261014_before_cut.tex`）。各 cut の old/new は `paper/backup/length_cut_20261014/log5.json`。

## 1. Phase 1（規則 1–4 の範囲、67 cuts、−1,279 語）

| Section | before | after | target | gap | cuts |
|---|---:|---:|---:|---:|---|
| Introduction | 1,246 | 1,085 | 950 | +135 | 10 / −161 |
| Methods | 3,173 | 2,746 | 2,500 | +246 | 17 / −427 |
| Simulation | 3,253 | 2,988 | 2,300 | +688 | 19 / −265 |
| Application | 1,658 | 1,400 | 1,300 | +100 | 14 / −258 |
| Discussion | 1,767 | 1,599 | 1,300 | +299 | 7 / −168 |
| **Total** | **11,097** | **9,818** | **9,000** | **+818** | **67 / −1,279** |

Tier: F（自由）23 / −364、R2c（数値・限定句・引用を保った圧縮）24 / −331、R2d（実質重複の削除）4 / −113、R3d（承認段落の反復の純削除）3 / −33、R3n（**拒否権項目**）12 / −406、B（S17 log-scale SMD）1 / −32。規則 2 の読み: marker は理由が名指す文を守る（段落全体ではない）。数値を表に移す cut は全部 revert した（§3.1.3 の 14 数値、basic 区間の括弧、拡張 cell の n）。

## 2. 拒否権項目（Tak、12 件、marker 13 行）

| # | id | line | 段落 | 語 | 内容 |
|---|---|---:|---|---:|---|
| 1 | I09 | 109 | §1 roadmap | −23 | 4 文 → 節ごとに 1 句 |
| 2 | M13 | 146 | §2.1 limitations | −23 | KL 非対称の説明句を落とし末尾 2 文を結合 |
| 3 | M14 | 169 | §2.2 units | −24 | 冒頭と "Consequently" を統合 |
| 4 | M03 | 200 | §2.2 sharpness | −13 | KS の step-CATE 文 → pointer（本文は A.3 へ verbatim） |
| 5 | M04 | 206 | §2.2 attainment | −70 | [a,b] / lipRange / Lee / 非有界な台の文 → 1 句 + pointer（A.3 へ） |
| 6 | M12 | 208 | §2.2 closing | −93 | "The reason to prefer … to the KS bound" を削除（§2.2 冒頭の三つの理由・§2.1・A.3 末尾に残る） |
| 7 | M17 | 271 | §2.4 L_UB | −18 | "L* reported for every pair" の反復と deft 文を落とす（fisher2017 は引用維持） |
| 8 | A13 | 637 | §4.4 第 1 段落 | −42 | 削除（bound は §2.4 と Table 9 注に） |
| 9 | D01 | 665 | §5 ¶1 末尾（plan D08） | −36 | coverage 範囲と MCSE 数 → §3.2.2 への pointer |
| 10 | D04 | 692 | §5 ¶4 冒頭（plan D09） | −29 | Study 1 の再掲を落とし三つの限界を一文に |
| 11 | D06 | 721 | §5 Lipschitz First/Second（plan D14） | −27 | 2 文を統合、"Third" → "Second" |
| 12 | D07 | 722 | §5 Lipschitz locality + additive（C-21） | −8 | "assumes the CATE varies with that modifier alone" を落とす（Prop. 1 と abstract に残る）；式と限定句は維持 |

## 3. CLAIMS への影響（規則 1）
- 唯一の担い手を失った supported/narrowed 行: **なし**
- **C-28（pending）は S17 で retract**（log-scale SMD の文を省略宣言に畳んだ → C-40 の wording が真になる）
- C-09: §5 ¶1 は pointer に。担い手は abstract・§3.2.2・§5 limitations
- C-05 / C-16: lipRange と Lee の比較は A.3 に、§2.2 には 1 句
- C-15 / C-16: §2.1・§2.2 冒頭・A.3 が担う。C-21: 圧縮のみ（D16 不適用）。C-25: §2.4 と Table 9 注。C-43: R6 の例は一文、推定値は Table 8
- **表番号（compiled）**: estimation 3（旧 bias 3 / coverage 4 / precision 7）、intervals 4、extension 5、Region 8 6、null floor 7、per-pair W₁ 8、L* 9

## 4. 表の統合
- `tab_estimation.tex`: 21 行（S1–S7 × n）、列 Scenario | True W₁ | n | Bias | Coverage | RMSE | Mean CI width。精度不変、S1 coverage 0.000。生成器 1 本（tab_bias / tab_coverage / tab_precision は削除）。84 値すべて旧表と一致
- `tab_study2_ext.tex`: 設計順（E1、E2、E3 100/200/1,000、E4、E5、E6）、ラベル "E5 small distance" / "E6 small distance, unequal n, rounded"、`\tabcolsep` 4pt、overfull 解消
- 他の生成表 6 本は byte 一致

## 5. ゲート（Phase 1 後）
| gate | result |
|---|---|
| claim_guards --strict | 59 guards, 0 FAIL |
| structure_audit | 9,818 語；abstract 250/250（byte 一致）；floats 13、placement 0 |
| refs / cites | dangling 0；bib に無い key 0；1 回しか出ない cite key 20 本すべて維持 |
| registry | check PASS（163 used / 235 defined）；verify-draft 235 match |
| numbers_audit | 141 tokens, 0 unsourced |
| build | 0 errors, 0 undefined, 22 pages |
| verify_study2_figures / verify_study1_app_numbers | ALL PASS |

未使用になった registry key 12（行は残す）: aucSMDlogShapeN2000, aucSMDlogCombinedN2000, w1AgeR6, w1SbpR6, ciLoSbpR6, ciHiSbpR6, covS3rangeN100up, covS4rangeN100up, covS6rangeN100up, covS7rangeN100up, covS2n50note, covS5n50note。

## 6. Menu（818 語の差を埋める選択肢、単独で実測）と Harvey の選択（01:05）
| option | section | words | Harvey |
|---|---|---:|---|
| §1「EM がどこまで既知か」段落の削除 | Intro | −107 | **採用** |
| Set 4 control check の付録移動 | Simulation | −94 | 不採用（reviewer が求めた証拠） |
| §4.1 post hoc 感度・heaping の付録移動 | Application | −83 | 不採用 |
| 拡張段落を 2 文に、cell list は表の注へ | Simulation | −85 | **採用** |
| §2.4 Lee の算術の付録移動 | Methods | −75 | **採用**（結論の一句は本文に） |
| basic 区間の文の付録移動 | Simulation | −76 | 不採用 |
| §4.2「null の source」段落の削除 | Application | −65 | **採用**（permutation 文に一句で残す） |
| §2.3 Jensen の導出の付録移動 | Methods | −63 | **採用**（命題は本文に） |
| §5 RWE 段落の削除 | Discussion | −62 | 不採用（C-39 の唯一の担い手） |
| §4.3 記述段落の削除 | Application | −61 | **採用**（範囲は Table 8） |
| §4.4 単調係数の文の付録移動 | Application | −49 | 不採用 |
| D16 additive 節 | Discussion | −48 | 不採用（C-21 を narrow） |
| 「separable」段落の削除 | Discussion | −42 | **採用**（承認段落 → 拒否権） |
| roadmap の削除 | Intro | −41 | 不採用 |

採用合計 ≈ −450 → 約 9,400 語（1.5×）。それ以上は reviewer が求めた証拠か主張の担い手を削ることになるため、ここで止める（Harvey、Jessica Go）。

## 7. Phase 2（Menu 適用）— Katrina の報告を追記

Phase 2（Menu 1–7、01:07）: 9,818 → **9,461**（−357）。Intro 978 / Methods 2,700 / Simulation 2,928 / Application 1,298（目標達成）/ Discussion 1,557。適用: H1 §1 段落削除 −107；H2 §4.2 null source 段落削除 −65 と permutation 文への一句 +24；H3 §4.3 記述段落削除 −61；H4 separable 段落削除 −42（拒否権）；H5 拡張段落 2 文化、cell list は Table 5 注へ −60；H6 Jensen の導出を A.1 へ（命題は §2.3 に、enrolled sample の式は維持）−22（拒否権）；H7 Lee の算術を A.3 へ（結論の一句と "a reference point rather than a guarantee" は §2.4 に）−24（拒否権）。拒否権項目は計 15（marker 17 行）。CLAIMS: C-11 は rank interval 段落・R2/R9 段落・§5 が担う、C-45 は §2.3 + A.1、C-25 は §2.4 + A.3。未使用 key 76（+ w1AgeR3, w1AgeR5, w1SbpR2, w1SbpR9 — 値は Table 8）。ゲート: guards 59 / 0 FAIL、abstract 250/250（byte 一致）、dangling 0、registry check PASS、unsourced 0（142 tokens）、build 0 / 0 / **21 pp**、verify 2 本 ALL PASS。Harvey: 9,000 には届かないが、残りは主張の担い手と reviewer が求めた証拠 — ここで止める（1.6×）。


## 8. Louis `/review-fix`（`FIX_REVIEW_LOUIS_20261014_cut.md`、Major 9 / Minor 13）→ 復元 01:30
- K1/K2 M12 の一句（sharpness は KS にもある、定数が区別する；主語を名指し）、K3 D01 を数値付きで復元、K4 EM 選択の射程を §5 limitations に、K5 log-scale SMD の AUC を省略宣言の括弧に（C-28 pending に戻す）、K6 τ* の baseline-risk 句に L_UB を明示、K7 A.3 の back-pointer を \cite に、K8 CLAIMS の evidence path を tab_estimation に、K9 amendment の 3 cell（E5・E6・E3c）、Minor の壊れた文。Harvey の K4 marker が本文を飲み込み → 自動検査で検出・分割
- 最終: **9,617 語**、21 pp、guards 59 / 0 FAIL、unsourced 0、verify ALL PASS、swallow 0
- 新しく記録した型（memory `feedback_fix_explanations_checked`）: 移設で back-pointer が壊れる／二つの cut が互いに「向こうが担う」と仮定して唯一の担い手を両方消す
