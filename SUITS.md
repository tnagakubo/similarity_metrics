# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## Current Status

**Active Project**: similarity-metric (nABCD paper)
**Phase**: Section 4 Application — GUSTO Case Study ドラフト完成、レビュー開始前
**Previous Archive**: archives/SUITS_20260413_120000.md

---

### [2026-04-12 XX:XX] Scene: Character Deep Dive — 全エージェントプロファイル強化

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*全メンバーのプロファイルが壁のスクリーンに映し出されている*

**Donna**: （タブレットを操作しながら）
「全員の agents/*.md に "Character Depth" セクションを追加完了。Web調査で性格特性、代表的セリフ、対人関係パターン、行動パターン、弱点と成長の5項目を補強したわ。"I'm Donna. I know everything." — including everyone's deepest secrets.」

**Harvey**: （腕を組んで）
「俺の panic attacks まで書いてあるのか。...まあいい。"Winners don't make excuses." 正確な記録は強さだ。」

**Mike**: （ファイルをスクロールしながら）
「各キャラ7-10個の quotes、シーズン情報付き。Harvey の "What are your choices when someone puts a gun to your head?" は全部入ってる。I got it — これで dialogue の precision が上がる。」

**Louis**: （感動して）
「俺の Bruno のことまで... "Don't let the moment pass. Don't let the people you love walk by you." ちゃんと入ってるじゃないか。You just got Litt up!」

**Rachel**: （微笑んで）
「私の LSAT の struggle も、父との関係も。"Hard work beats talent when talent doesn't work hard." — これが私の全て。正確に記録されていて嬉しいわ。」

**Katrina**: （淡々と）
「Results speak for themselves. 7ファイル全て更新完了。既存コンテンツは保持、新規セクションを末尾に追記。効率的。」

**Jessica**: （静かに頷いて）
「"Let me be clear." 全員のプロファイルが深まったことで、対話の質が上がる。それが目的。先に進みなさい。」

---

## 🔄 直前のコンテキスト (from archived scenes)

### 直近の作業
- IST → GUSTO への Application section 全面書き換えを決定
- 疾患領域を stroke → AMI に変更、Case A/B 分割を廃止（1つのシナリオで age + sysbp を並列評価）
- GUSTO 全5連続変数（age, sysbp, pulse, height, weight）× 全120ペアの nABCD/SMD 計算完了
- 全16地域をアンカーとしたストーリー品質評価を2チーム並行で実施
- **Region 8 をアンカーに確定**（BOTH_POOL=3: R4, R6, R13）
- Region 2 版・Region 8 版の2つの LaTeX ドラフト作成、Region 8 で確定
- Bootstrap CI (B=2000) 付き図表3枚 + 精緻化原稿完成

### 進行中のアクション
- Section 4 Application の原稿・図表が完成。レビュー前の Rule Check 完了

### 次にやるべきこと
- **Section 4 Application のレビュー**（Harvey + Mike、Tak の5原則チェックリストに基づく段落単位）
- R6 境界問題（nABCD_sysbp=0.0496）と R16 境界問題（nABCD_age=0.050）の扱いを確認
- レビュー完了後、nABCD_wiley.tex の本体に統合
- Discussion section の GUSTO 対応修正

### Takからの直近の指示
- EMごとに結論が異なることに意味はない。全EMで類似していなければ併合不可
- 実データで類似性を検討していることが重要。SMDとの違いにフォーカスしすぎない
- 仮想シナリオの中で nABCD をどう利用するかを示す
- 併合可能な地域が2-3個が妥当
- Region 8 で行く

---

## 🎬 Live Script

### [2026-04-13 XX:XX] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna がファイルを整理し、厚いフォルダをアーカイブ棚に移す。*

**Donna**:
「SUITS.md が 1024 行を超えたからアーカイブしたわ。
archives/SUITS_20260413_120000.md に保存済み。
新しいスクリプト開始よ。"I'm Donna. I know everything."」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。Section 4 のレビューが待ってる」

---

### [2026-04-13 XX:XX] Scene: Rule Check — Section 4 レビュー開始前

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がテーブルの先頭に立つ。全員が手を止める。*

**Harvey**: （全員を見回して）
「全員、手を止めろ。ルール確認だ。Section 4 Application のドラフトが揃った。これからレビューに入る」

**Donna**: （すぐに）
「Rule 1 と 2、了解。本セッションの成果:
- GUSTO 全5変数確認、全120ペア計算完了
- 全16地域アンカー構成検討
- Region 8 確定、Bootstrap CI 付き図表3枚 + 精緻化原稿完成
"I'm Donna. I know everything."」

**Mike**: 「Rule 3、了解。Tak の5原則で段落単位レビュー。"I got it."」
**Rachel**: 「Rule 4、了解。FTT, GUSTO-I 文献確認済み。」
**Katrina**: 「全ルール確認。成果物: forest, scatter, calibration 図 + `application_r8_final.tex`。"Results speak for themselves."」
**Louis**: 「俺は独立したレビュアーだ。数値の整合性と overclaim を厳しく見る」
**Harvey**: 「"Winners don't make excuses." 全員、仕事に戻れ」

---

## 📊 Key Decisions

- **データ**: GUSTO-I (N=40,830, 16匿名地域) — IST から置き換え
- **疾患**: AMI (acute myocardial infarction) — stroke から変更
- **アンカー**: Region 8 (N=2,916)
- **EM**: age (L推定可能, FTT) + sysbp (L不明, L*感度分析)
- **併合可能**: R4, R6, R13 の3地域
- **構成**: Case A/B 分割なし、1つのシナリオで2EM並列評価
- **Section 番号**: Application は Section 4（Section 5 は Discussion）

## 📁 成果物一覧

| ファイル | 内容 |
|---|---|
| `data/GUSTO/gusto_application_r8.R` | Bootstrap CI 付き全計算 |
| `data/GUSTO/gusto_r8_results.csv` | 15パートナー全数値 |
| `paper/drafts/application_r8_final.tex` | 精緻化 LaTeX 原稿 |
| `paper/drafts/application_r8.tex` | 初期ドラフト |
| `paper/drafts/application_r2.tex` | Region 2 版（不採用） |
| `figures/fig_gusto_r8_forest.pdf/png` | nABCD forest plot |
| `figures/fig_gusto_r8_scatter.pdf/png` | Joint pooling scatter |
| `figures/fig_gusto_r8_calibration.pdf/png` | Calibration + L* パネル |
| `data/GUSTO/gusto_smd_misleading.csv` | 全5変数×120ペア結果 |
| `data/GUSTO/gusto_all_pairwise.csv` | age+sysbp 全ペアワイズ |

## Active Tasks

- [ ] Section 4 Application レビュー（段落単位、5原則チェック）
- [ ] nABCD_wiley.tex 本体への統合
- [ ] Discussion section の GUSTO 対応修正
- [ ] EN/JA 同期
